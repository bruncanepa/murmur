import SwiftUI

struct ContentView: View {
    @ObservedObject var speechRecognizer: SpeechRecognizer

    var body: some View {
        VStack(spacing: 16) {
            // Status indicator
            HStack {
                Circle()
                    .fill(speechRecognizer.isRecording ? Color.red : Color.gray)
                    .frame(width: 12, height: 12)

                Text(speechRecognizer.isRecording ? "Recording..." : "Ready")
                    .font(.headline)
            }

            // Language selector
            HStack {
                Text("Language:")
                    .font(.subheadline)

                Spacer()

                Picker("", selection: $speechRecognizer.currentLanguage) {
                    ForEach(RecognitionLanguage.allCases, id: \.self) { language in
                        Text(language.displayName).tag(language)
                    }
                }
                .pickerStyle(.menu)
                .disabled(speechRecognizer.isRecording)
            }

            // Auto-type toggle
            Toggle("Auto-type to active app", isOn: $speechRecognizer.autoTypeEnabled)
                .font(.subheadline)
                .disabled(speechRecognizer.isRecording)

            // On-device recognition toggle
            Toggle("On-device recognition (offline, more private)", isOn: $speechRecognizer.onDeviceRecognitionEnabled)
                .font(.subheadline)
                .disabled(speechRecognizer.isRecording)

            // Editable transcribed text
            TextEditor(text: $speechRecognizer.transcribedText)
                .font(.body)
                .frame(height: 100)
                .padding(4)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .overlay(
                    Group {
                        if speechRecognizer.transcribedText.isEmpty {
                            Text("Hold right ⌘ to record")
                                .foregroundColor(.secondary)
                                .font(.body)
                                .allowsHitTesting(false)
                        }
                    }
                )

            // Controls
            HStack {
                Button(speechRecognizer.isRecording ? "Stop" : "Start") {
                    if speechRecognizer.isRecording {
                        // Manual stop - don't auto-type
                        speechRecognizer.stopRecording(autoType: false)
                    } else {
                        speechRecognizer.startRecording()
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Copy") {
                    speechRecognizer.copyToClipboard()
                }
                .buttonStyle(.bordered)
                .disabled(speechRecognizer.transcribedText.isEmpty)

                Button("Clear") {
                    speechRecognizer.clearText()
                }
                .buttonStyle(.bordered)
            }

            // Quit button
            HStack {
                Spacer()

                Button("Quit Murmur") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.borderless)
                .foregroundColor(.secondary)
                .font(.caption)
                .disabled(speechRecognizer.isRecording)

                Spacer()
            }

            // Permission status
            if let error = speechRecognizer.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .frame(width: 300)
    }
}
