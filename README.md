# Murmur - Private Voice Dictation

A privacy-first voice dictation app for macOS that runs completely offline using native macOS Speech Recognition.

## Features

- ✅ Menu bar app with system tray icon
- ✅ Real-time speech-to-text using native macOS Speech Recognition
- ✅ Press-and-hold recording with right Command (⌘) key
- ✅ Auto-type transcribed text into any application
- ✅ Editable transcription with automatic session restart
- ✅ Multi-language support (English and Spanish)
- ✅ Clipboard integration
- ✅ 100% private - no internet required

## Building and Running

### Quick Start (Recommended)
```bash
./run.sh
```

This script will:
- Stop any running instance
- Clean previous builds
- Build a fresh app bundle with proper entitlements
- Launch the app automatically

### Manual Build
```bash
./build-app.sh
open Murmur.app
```

### Xcode
1. Open Terminal and navigate to the project directory
2. Generate Xcode project:
   ```bash
   swift package generate-xcodeproj
   ```
3. Open `Murmur.xcodeproj` in Xcode
4. Select "Murmur" scheme
5. Click Run (Cmd+R)

**Note:** `swift run` won't work directly due to privacy/entitlement requirements. Use the run script, build script, or Xcode.

## First Run

On first launch, macOS will ask for permissions:
1. **Microphone Access** - Required to capture your voice
2. **Speech Recognition** - Required to transcribe speech
3. **Accessibility** - Required to type into other applications (prompted when auto-type is enabled)

Grant all permissions for the app to work properly. After granting Accessibility permissions, you may need to restart the app.

## Usage

### Quick Dictation (Recommended)

1. Focus any text field in any application (email, document, browser, etc.)
2. **Hold down the right Command (⌘) key** to start recording
3. Speak naturally in your selected language
4. **Release the right Command (⌘) key** to stop recording
5. The transcribed text will automatically appear in your focused text field!

### Manual Control

1. Click the menu bar icon (waveform symbol) to open the control panel
2. **Select your language** (English or Spanish) from the dropdown
3. **Toggle "Auto-type to active app"** to enable/disable automatic typing
4. Click "Start" to begin recording (or use the hotkey)
5. Speak naturally in your selected language
6. The transcription appears in real-time and can be edited
7. Click "Stop" to end recording
8. With auto-type enabled: text is automatically typed into the previously active application
9. With auto-type disabled: click "Copy" to copy text to clipboard, then paste anywhere

### Advanced Features

**Editing During Recording:**
- You can click in the text field and manually edit the transcription while recording
- The app will automatically stop and restart the recognition session, preserving your edits
- New speech will continue after your edited text

**Language Support:**
- 🇺🇸 English (en-US)
- 🇪🇸 Spanish (es-ES)

**Note:** Language and auto-type settings cannot be changed while recording is in progress.

## Privacy

- All processing happens locally on your Mac
- No internet connection required
- No data sent to external servers
- Uses native macOS Speech Recognition framework

## Requirements

- macOS 13.0 (Ventura) or later
- Microphone
- Swift 5.9+

## Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Privacy Commitment

Murmur is committed to being 100% private:
- ✅ All processing happens locally on your Mac
- ✅ No telemetry, analytics, or tracking
- ✅ No network requests
- ✅ No data collection of any kind
- ✅ Open source - verify for yourself

## Roadmap

### Future Enhancements
- Additional language support
- Local LLM integration for:
  - Filler word removal ("um", "uh", "like")
  - Auto-formatting and punctuation
  - Grammar improvements
- Personal dictionary for custom words/names
- Voice shortcuts/snippets
- Per-application preferences
- Alternative speech recognition engines (whisper.cpp)

## Support

- 🐛 **Bug reports**: [Open an issue](https://github.com/bruncanepa/murmur/issues)
- 💡 **Feature requests**: [Open an issue](https://github.com/bruncanepa/murmur/issues)
- 📖 **Documentation**: Check [QUICKSTART.md](QUICKSTART.md)

## Acknowledgments

Built with native macOS technologies:
- Speech Framework (SFSpeechRecognizer)
- SwiftUI
- AVFoundation

Inspired by the need for privacy-focused alternatives to cloud-based dictation services.

## License

MIT License - see [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Bruno Canepa
