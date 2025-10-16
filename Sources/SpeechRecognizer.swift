import Foundation
import Speech
import Combine
import AppKit
import AVFoundation
import UserNotifications

enum RecognitionLanguage: String, CaseIterable {
    case english = "en-US"
    case spanish = "es-ES"

    var displayName: String {
        switch self {
        case .english: return "English"
        case .spanish: return "Spanish"
        }
    }
}

class SpeechRecognizer: ObservableObject {
    @Published var transcribedText: String = "" {
        didSet {
            // Detect if user manually edited the text
            if isRecording && !isUpdatingFromRecognition {
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

    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechRecognizer: SFSpeechRecognizer?
    private var isUpdatingFromRecognition: Bool = false // Flag to track programmatic updates
    private var baseText: String = "" // Base text that new recognition should append to

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

    func startRecording() {
        // Check if already recording
        guard !isRecording else { return }

        // Check authorization
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
            errorMessage = "Speech recognition not authorized"
            return
        }

        // Store the current text as base for new recognition
        baseText = transcribedText

        // Cancel any ongoing task
        if let task = recognitionTask {
            task.cancel()
            recognitionTask = nil
        }

        // Create and configure recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            errorMessage = "Unable to create recognition request"
            return
        }
        recognitionRequest.shouldReportPartialResults = true

        // Create audio engine and input node
        audioEngine = AVAudioEngine()
        guard let audioEngine = audioEngine else {
            errorMessage = "Unable to create audio engine"
            return
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        // Install tap on input node
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        // Start audio engine
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            errorMessage = "Audio engine failed to start: \(error.localizedDescription)"
            return
        }

        // Verify speech recognizer is available for the selected language
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            errorMessage = "Speech recognition not available for \(currentLanguage.displayName)"
            return
        }

        // Start recognition
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                let newRecognition = result.bestTranscription.formattedString

                DispatchQueue.main.async {
                    self.isUpdatingFromRecognition = true

                    // Append new recognition to the base text
                    if self.baseText.isEmpty {
                        self.transcribedText = newRecognition
                    } else {
                        self.transcribedText = self.baseText + " " + newRecognition
                    }

                    self.isUpdatingFromRecognition = false
                }
            }

            if error != nil || result?.isFinal == true {
                audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                DispatchQueue.main.async {
                    self.isRecording = false
                }
            }
        }

        isRecording = true
        errorMessage = nil
    }

    func stopRecording() {
        // Cancel recognition task
        recognitionTask?.cancel()
        recognitionTask = nil

        // Stop audio engine and remove tap
        if let audioEngine = audioEngine {
            if audioEngine.isRunning {
                audioEngine.stop()
            }
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        // End recognition request
        recognitionRequest?.endAudio()
        recognitionRequest = nil

        isRecording = false
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
        // Stop the current recording session
        stopRecording()

        // Restart after a brief delay to ensure cleanup is complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.startRecording()
        }
    }

    func clearText() {
        // Check if currently recording
        let wasRecording = isRecording

        // Stop recording if currently active
        if wasRecording {
            stopRecording()
        }

        // Clear all text and reset flags
        isUpdatingFromRecognition = true
        transcribedText = ""
        baseText = ""
        isUpdatingFromRecognition = false

        // Clear any error messages
        errorMessage = nil

        // Restart recording if it was active
        if wasRecording {
            // Delay to ensure complete cleanup before restarting
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.startRecording()
            }
        }
    }
}
