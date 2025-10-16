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

                Picker("Language", selection: $speechRecognizer.currentLanguage) {
                    ForEach(RecognitionLanguage.allCases, id: \.self) { language in
                        Text(language.displayName).tag(language)
                    }
                }
                .pickerStyle(.menu)
                .disabled(speechRecognizer.isRecording)
            }

            // Transcribed text preview
            ScrollView {
                Text(speechRecognizer.transcribedText.isEmpty ? "Press Cmd+Shift+Space to start dictation" : speechRecognizer.transcribedText)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
            }
            .frame(height: 100)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)

            // Controls
            HStack {
                Button(speechRecognizer.isRecording ? "Stop" : "Start") {
                    if speechRecognizer.isRecording {
                        speechRecognizer.stopRecording()
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
