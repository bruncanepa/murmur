# PWhisper - Private Voice Dictation

A privacy-first voice dictation app for macOS that runs completely offline using native macOS Speech Recognition.

## Phase 1: Core Features

- ✅ Menu bar app with system tray icon
- ✅ Real-time speech-to-text using NSSpeechRecognizer
- ✅ Global hotkey support (Cmd+Shift+Space)
- ✅ Clipboard integration
- ✅ Microphone and speech recognition permissions
- ✅ Multi-language support (English and Spanish)

## Building

### Option 1: Build App Bundle (Recommended)
```bash
./build-app.sh
open PWhisper.app
```

This creates a proper macOS app bundle with entitlements for microphone and speech recognition access.

### Option 2: Xcode
1. Open Terminal and navigate to the project directory
2. Generate Xcode project:
   ```bash
   swift package generate-xcodeproj
   ```
3. Open `PWhisper.xcodeproj` in Xcode
4. Select "PWhisper" scheme
5. Click Run (Cmd+R)

**Note:** `swift run` won't work directly due to privacy/entitlement requirements. Use the build script or Xcode.

## First Run

On first launch, macOS will ask for permissions:
1. **Microphone Access** - Required to capture your voice
2. **Speech Recognition** - Required to transcribe speech

Grant both permissions for the app to work.

## Usage

1. Click the menu bar icon (waveform symbol) to open the control panel
2. **Select your language** (English or Spanish) using the segmented control
3. Click "Start" or press **Cmd+Shift+Space** to begin recording
4. Speak naturally in your selected language
5. Click "Stop" or press **Cmd+Shift+Space** again to end recording
6. Click "Copy" to copy the transcribed text to clipboard
7. Paste anywhere with Cmd+V

**Language Support:**
- 🇺🇸 English (en-US)
- 🇪🇸 Spanish (es-ES)

Note: You cannot change language while recording is in progress.

## Privacy

- All processing happens locally on your Mac
- No internet connection required
- No data sent to external servers
- Uses native macOS Speech Recognition framework

## Requirements

- macOS 13.0 (Ventura) or later
- Microphone
- Swift 5.9+

## License

MIT
