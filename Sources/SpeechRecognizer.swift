import Foundation
import Speech
import Combine
import AppKit
import AVFoundation
import UserNotifications

enum RecognitionLanguage: String, CaseIterable {
    case english = "en-US"
    case spanish = "es-ES"
    case portuguese = "pt-BR"

    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Spanish"
        case .portuguese: return "Portuguese"
        }
    }
}

class SpeechRecognizer: ObservableObject {
    @Published var transcribedText: String = "" {
        didSet {
            // Detect if user manually edited the text
            if isRecording && !isUpdatingFromRecognition && !isRestartingAfterEdit {
                // User edited while recording - restart the session
                restartRecordingAfterEdit()
            }
        }
    }
    @Published var isRecording: Bool = false
    @Published var errorMessage: String?
    @Published var currentLanguage: RecognitionLanguage = .english {
        didSet {
            // Update speech recognizer when language changes
            speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: currentLanguage.rawValue))
        }
    }
    @Published var autoTypeEnabled: Bool = true // Auto-type when recording stops
    @Published var onDeviceRecognitionEnabled: Bool = true // Use on-device recognition (offline, private)

    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechRecognizer: SFSpeechRecognizer?
    private var isUpdatingFromRecognition: Bool = false // Flag to track programmatic updates
    private var historicalResults: [SFSpeechRecognitionResult] = [] // Finalized results
    private var fullTranscription = "" // Accumulated final transcription
    private var isRestartingAfterEdit: Bool = false // Flag to prevent multiple restart triggers
    private var isRestartingSession: Bool = false // Flag to prevent concurrent time limit restarts
    private let audioLock = NSLock() // Protect audio engine operations
    private var lastPartialText = "" // Track previous partial to detect session splits
    private var lastSegmentCount = 0 // Track segment count to detect real splits vs refinements

    init() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: currentLanguage.rawValue))
        requestPermissions()
    }

    func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self?.errorMessage = nil
                case .denied:
                    self?.errorMessage = "Speech recognition permission denied"
                case .restricted:
                    self?.errorMessage = "Speech recognition restricted on this device"
                case .notDetermined:
                    self?.errorMessage = "Speech recognition not yet authorized"
                @unknown default:
                    self?.errorMessage = "Unknown authorization status"
                }
            }
        }
    }

    func startRecording(isRestart: Bool = false) {
        audioLock.lock()
        defer { audioLock.unlock() }

        print("🔍 startRecording called - isRestart: \(isRestart), currentText: '\(transcribedText)'")

        // Check if already recording (skip check if this is a restart)
        guard isRestart || !isRecording else {
            print("⚠️ Already recording, ignoring startRecording call")
            return
        }

        // Check authorization
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Speech recognition not authorized"
            }
            return
        }

        // Cancel any ongoing task
        if let task = recognitionTask {
            task.cancel()
            recognitionTask = nil
        }

        // Create and configure recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Unable to create recognition request"
            }
            return
        }
        recognitionRequest.shouldReportPartialResults = true

        // Enable automatic punctuation (like iPhone) - requires macOS 13.0+
        if #available(macOS 13.0, *) {
            recognitionRequest.addsPunctuation = true
        }

        // Use on-device recognition if enabled (offline, private, but slightly less accurate)
        recognitionRequest.requiresOnDeviceRecognition = onDeviceRecognitionEnabled

        // Optimize for dictation (long-form text entry)
        recognitionRequest.taskHint = .dictation

        // Create audio engine and input node
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Unable to create audio engine"
            }
            return
        }

        let inputNode = audioEngine.inputNode

        // Validate audio format before installing tap
        guard inputNode.numberOfInputs > 0 else {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "No audio input available"
            }
            return
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)

        // Validate recording format
        guard recordingFormat.sampleRate > 0 && recordingFormat.channelCount > 0 else {
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Invalid audio format"
            }
            return
        }

        // Install tap on input node
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        // Start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            // Clean up tap if engine failed to start
            if inputNode.numberOfInputs > 0 {
                inputNode.removeTap(onBus: 0)
            }
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Audio engine failed to start: \(error.localizedDescription)"
            }
            return
        }

        // Verify speech recognizer is available for the selected language
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            // Clean up before returning
            audioEngine.stop()
            if inputNode.numberOfInputs > 0 {
                inputNode.removeTap(onBus: 0)
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.errorMessage = "Speech recognition not available for \(self.currentLanguage.displayName)"
            }
            return
        }

        // Start recognition
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                let currentText = result.bestTranscription.formattedString

                DispatchQueue.main.async {
                    self.isUpdatingFromRecognition = true

                    if result.isFinal {
                        // Append finalized result to history
                        self.historicalResults.append(result)
                        self.fullTranscription += (self.fullTranscription.isEmpty ? "" : " ") + currentText
                        print("✅ Final full text: \(self.fullTranscription)")
                        self.transcribedText = self.fullTranscription
                    } else {
                        // For partial results, detect real session splits using segment analysis
                        let segments = result.bestTranscription.segments
                        let currentSegmentCount = segments.count

                        // Detect real split: dramatic segment drop indicating a new sentence
                        // On-device recognition resets segments when starting a new utterance
                        // Criteria:
                        //   1. Previous had substantial text (>5 segments) and drops to very few (≤3)
                        //   2. Text has changed (not just re-segmentation of same text)
                        let hasDramaticDrop = self.lastSegmentCount > 5 && currentSegmentCount <= 3
                        let hasNewText = currentText != self.lastPartialText

                        if !self.lastPartialText.isEmpty && hasDramaticDrop && hasNewText {
                            // Real session split detected - save previous partial before it's lost
                            self.fullTranscription += (self.fullTranscription.isEmpty ? "" : " ") + self.lastPartialText
                            print("🔄 Session split detected:")
                            print("   Segments: \(self.lastSegmentCount) → \(currentSegmentCount)")
                            print("   Saved: '\(self.lastPartialText)'")
                            print("📝 Full transcription now: '\(self.fullTranscription)'")
                        } else if hasDramaticDrop && !hasNewText {
                            print("🔄 Re-segmentation detected (same text): \(self.lastSegmentCount) → \(currentSegmentCount)")
                        }

                        // Update tracking for next iteration
                        self.lastPartialText = currentText
                        self.lastSegmentCount = currentSegmentCount

                        // Display accumulated + current
                        let displayText = self.fullTranscription.isEmpty ? currentText : self.fullTranscription + " " + currentText
                        self.transcribedText = displayText
                        print("⏳ Partial (\(currentSegmentCount) segments): '\(displayText)'")
                    }

                    self.isUpdatingFromRecognition = false
                }
            }

            // Handle completion - ONLY on actual errors, not on isFinal
            // On-device recognition marks results as final frequently (after punctuation)
            // but the recognition continues in the same session - don't restart!
            if let error = error {
                let nsError = error as NSError

                // Check if this is the time limit error (on-device recognition ~1 minute limit)
                let isTimeLimitError = nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 1101

                if isTimeLimitError && self.isRecording && !self.isRestartingSession {
                    // Time limit hit while still recording - restart seamlessly
                    // Set flag to prevent concurrent restart attempts
                    self.isRestartingSession = true
                    print("⏱️ Recognition time limit hit, restarting...")

                    // Safely stop the audio engine
                    self.audioLock.lock()
                    if let engine = self.audioEngine, engine.isRunning {
                        engine.stop()
                        let node = engine.inputNode
                        if node.numberOfInputs > 0 {
                            node.removeTap(onBus: 0)
                        }
                    }
                    self.audioLock.unlock()

                    self.recognitionRequest = nil
                    self.recognitionTask = nil

                    // Save current transcription and restart
                    DispatchQueue.main.async {
                        self.fullTranscription = self.transcribedText
                        print("💾 Saved full transcription before restart: '\(self.fullTranscription)'")

                        // Restart after longer delay to avoid conflicts
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                            guard let self = self, self.isRecording else {
                                self?.isRestartingSession = false
                                return
                            }
                            print("🔄 Restarting recognition after time limit...")
                            self.isRestartingSession = false
                            self.startRecording(isRestart: true)
                        }
                    }
                } else if isTimeLimitError && self.isRestartingSession {
                    // Ignore duplicate time limit errors during restart
                    print("⏭️ Ignoring duplicate time limit error during restart")
                } else {
                    // Real error - stop recording
                    print("⚠️ Recognition error: \(error.localizedDescription)")

                    // Safely stop the audio engine
                    self.audioLock.lock()
                    if let engine = self.audioEngine, engine.isRunning {
                        engine.stop()
                        let node = engine.inputNode
                        if node.numberOfInputs > 0 {
                            node.removeTap(onBus: 0)
                        }
                    }
                    self.audioLock.unlock()

                    self.recognitionRequest = nil
                    self.recognitionTask = nil

                    DispatchQueue.main.async {
                        print("🛑 Stopping recording due to error")
                        self.isRecording = false
                        self.isRestartingSession = false
                        self.errorMessage = "Recognition error: \(error.localizedDescription)"
                    }
                }
            }
        }

        isRecording = true

        // Reset tracking variables for fresh recordings (not restarts)
        if !isRestart {
            lastPartialText = ""
            lastSegmentCount = 0
        }

        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = nil
        }
    }

    func stopRecording(autoType: Bool = true) {
        audioLock.lock()

        // Set flags first to prevent race conditions
        isRecording = false
        isRestartingSession = false

        // Stop audio engine first (no more input)
        if let audioEngine = audioEngine {
            if audioEngine.isRunning {
                audioEngine.stop()
            }

            // Safely remove tap
            let inputNode = audioEngine.inputNode
            if inputNode.numberOfInputs > 0 {
                inputNode.removeTap(onBus: 0)
            }
        }

        // Signal end of audio to allow final processing
        recognitionRequest?.endAudio()

        audioLock.unlock()

        // Give the recognizer time to process remaining buffers (300ms)
        // This ensures the last few words are captured before cleanup
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }

            self.audioLock.lock()

            // Now cancel and cleanup
            self.recognitionTask?.cancel()
            self.recognitionTask = nil
            self.recognitionRequest = nil

            self.audioLock.unlock()

            // Auto-type the transcribed text if enabled, requested, and not empty
            if autoType && self.autoTypeEnabled && !self.transcribedText.isEmpty {
                // No additional delay needed - focus should already be restored by closing popover
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    // Check and request permission if needed
                    if !AccessibilityManager.hasAccessibilityPermission() {
                        AccessibilityManager.requestAccessibilityPermission()
                        DispatchQueue.main.async {
                            self.errorMessage = "Please grant Accessibility permission in System Settings"
                        }
                        return
                    }

                    // Type the text using paste method (more reliable)
                    // macOS should have already restored focus by closing the popover
                    AccessibilityManager.pasteText(self.transcribedText)

                    // Clear text after typing (for hotkey flow)
                    // When autoType is false (manual Stop button), text stays visible
                    DispatchQueue.main.async {
                        self.isUpdatingFromRecognition = true
                        self.transcribedText = ""
                        self.fullTranscription = ""
                        self.historicalResults = []
                        self.lastPartialText = ""
                        self.lastSegmentCount = 0
                        self.isUpdatingFromRecognition = false
                    }
                }
            }
        }
    }

    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(transcribedText, forType: .string)

        // Show notification using UserNotifications framework
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Murmur"
                content.body = "Text copied to clipboard"
                content.sound = .default

                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                center.add(request)
            }
        }
    }

    private func restartRecordingAfterEdit() {
        audioLock.lock()

        // Set flag to prevent multiple restart triggers
        isRestartingAfterEdit = true

        // Save the edited text before stopping
        let editedText = transcribedText

        // Cancel the current recognition task silently without stopping the audio engine
        recognitionTask?.cancel()
        recognitionTask = nil

        // Stop audio engine properly
        if let audioEngine = audioEngine {
            if audioEngine.isRunning {
                audioEngine.stop()
            }
            let inputNode = audioEngine.inputNode
            if inputNode.numberOfInputs > 0 {
                inputNode.removeTap(onBus: 0)
            }
        }

        // End recognition request
        recognitionRequest?.endAudio()
        recognitionRequest = nil

        // Set isRecording to false temporarily
        isRecording = false

        audioLock.unlock()

        // Restore the edited text and restart after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let self = self else { return }

            // Restore the edited text (this won't trigger didSet because isRecording is false)
            self.isUpdatingFromRecognition = true
            self.transcribedText = editedText
            self.isUpdatingFromRecognition = false

            // Start recording with the edited text as the base
            self.startRecording()

            // Clear the restart flag
            self.isRestartingAfterEdit = false
        }
    }

    func clearText() {
        audioLock.lock()

        // Check if currently recording
        let wasRecording = isRecording

        audioLock.unlock()

        // Stop recording if currently active (don't auto-type when clearing)
        if wasRecording {
            stopRecording(autoType: false)
        }

        // Clear all text and reset flags
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isUpdatingFromRecognition = true
            self.transcribedText = ""
            self.fullTranscription = ""
            self.historicalResults = []
            self.lastPartialText = ""
            self.lastSegmentCount = 0
            self.isUpdatingFromRecognition = false

            // Clear any error messages
            self.errorMessage = nil
        }

        // Restart recording if it was active
        if wasRecording {
            // Delay to ensure complete cleanup before restarting
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.startRecording()
            }
        }
    }
}
