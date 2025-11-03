<div align="center">
  <h1>🎙️ Murmur</h1>
  <p>Privacy-first voice dictation for macOS that runs completely offline</p>

  [![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
  ![Platform](https://img.shields.io/badge/platform-macOS%2013.0%2B-brightgreen)
  ![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)
  ![GitHub stars](https://img.shields.io/github/stars/bruncanepa/murmur?style=social)

  <p>
    <a href="#quick-start">Quick Start</a> •
    <a href="#features">Features</a> •
    <a href="#usage">Usage</a> •
    <a href="#building">Building</a> •
    <a href="#contributing">Contributing</a>
  </p>

  <p>
    <strong>🌐 <a href="index.html">Visit website</a></strong>
  </p>
</div>

---

Murmur is a native macOS application that transforms your voice into text instantly, right where you need it. Built with privacy as the foundation, all processing happens locally on your Mac using Apple's native Speech Recognition framework - no internet required, no data collection, ever.

## Why Murmur?

In a world where most voice dictation services send your data to the cloud, Murmur takes a different approach: **your voice never leaves your Mac**. It's the dictation tool for those who value privacy, simplicity, and instant results.

**Perfect for:**
- 💻 Programmers or Vibe Coders
- 📧 Writing emails and messages
- 📝 Taking notes and documentation
- 💬 Chatting in messaging apps
- ✍️ Long-form writing and articles
- 🗣️ Anyone who thinks faster than they type

## Features

- 🔒 **100% Private**: All processing happens locally - no internet, no tracking, no data collection
- ⚡ **Press-and-Hold**: Hold right ⌘ key to record, release to auto-type - it's that simple
- 🎯 **Universal Input**: Automatically types into any application on your Mac
- ✏️ **Live Editing**: Edit transcriptions in real-time while recording
- 🌍 **Multi-Language**: Supports English, Spanish, and Portuguese
- 🎤 **Native Quality**: Uses macOS native Speech Recognition for accurate results
- 🗣️ **Continuous Speech**: Preserves all text across natural pauses when speaking multiple sentences
- 🖱️ **Menu Bar App**: Lives quietly in your menu bar, always ready
- ⚙️ **Flexible Modes**: Auto-type or manual copy - you choose the workflow

![Murmur App Interface](Assets/murmur-app-window.png)


## Quick Start

### Download & Install

**Option 1: Direct Download (Easiest)**

```bash
# Download and install with curl (bypasses macOS Gatekeeper)
curl -L -o Murmur.dmg https://github.com/bruncanepa/murmur/releases/latest/download/Murmur-1.0.0.dmg
open Murmur.dmg
# Drag Murmur.app to Applications folder
```

**Option 2: GitHub Releases**

1. Go to [Releases](https://github.com/bruncanepa/murmur/releases/latest)
2. Download `Murmur-X.X.X.dmg`
3. Open the DMG file
4. Drag Murmur.app to Applications folder
5. **First launch**: Right-click Murmur.app → "Open" (to bypass unidentified developer warning)

**Option 3: Build from Source**

```bash
# Clone the repository
git clone https://github.com/bruncanepa/murmur.git
cd murmur

# Build and run
./run.sh
```

### First Launch

1. Grant **Microphone** permission when prompted
2. Grant **Speech Recognition** permission when prompted
3. Grant **Accessibility** permission when prompted (required for auto-typing)
4. Look for the waveform icon 🌊 in your menu bar
5. You're ready to go!

> **Note**: Murmur is not notarized by Apple. On first launch, you may need to right-click the app and select "Open" to bypass the security warning. This is only needed once.

## Usage

### Quick Dictation (Recommended)

1. **Click in any text field** in any app (email, browser, notes, etc.)
2. **Hold down the right ⌘ (Command) key**
3. **Speak naturally**
4. **Release the key**
5. **Your text appears instantly!** ✨

### Manual Mode

1. Click the menu bar icon to open the control panel
2. Toggle **"Auto-type to active app"** off for manual control
3. Use **Start/Stop** buttons or the right ⌘ key to record
4. Click **Copy** to copy text to clipboard
5. Paste anywhere with ⌘+V

### Pro Tips

- **Edit while recording**: Click in the text field and make corrections - Murmur automatically restarts the session with your edits
- **Change languages**: Select English or Spanish from the dropdown (can't change during recording)
- **Clear and restart**: Use the Clear button to wipe the text and restart recording
- **Disable auto-type**: Turn off auto-type when you want to review before inserting

## Building

### Requirements

- macOS 13.0 (Ventura) or later
- Swift 5.9+
- Xcode Command Line Tools

### Build Scripts

**Development (recommended):**
```bash
./dev.sh                # Quick development build
./dev.sh --force        # Clean rebuild
```

**Production:**
```bash
./prod.sh               # Optimized production build
```

**Manual build:**
```bash
./build-app.sh --dev                    # Development
./build-app.sh --prod --version 1.0.0   # Production with version
open Murmur-Dev.app                     # or Murmur.app
```

**Create DMG installer:**
```bash
./build-app.sh --prod --version 1.0.0   # Build first
./create-dmg-installer.sh --version 1.0.0  # Create DMG
```

**For development in Xcode:**
```bash
swift package generate-xcodeproj
open Murmur.xcodeproj
```

> **Note**: `swift run` won't work directly due to entitlement requirements. Always use the provided build scripts or Xcode.
>
> **See [BUILD.md](BUILD.md) for detailed build documentation including permission management.**

## Privacy Commitment

Murmur is built with privacy at its core:

- ✅ **Zero network requests** - works completely offline
- ✅ **Zero telemetry** - no analytics, no tracking, no "anonymous" data
- ✅ **Zero cloud services** - your voice never leaves your Mac
- ✅ **Zero local storage** - transcriptions exist only in memory
- ✅ **Open source** - verify it yourself, build it yourself

See our [Security Policy](SECURITY.md) for more details.

## Roadmap

We're just getting started. Here's what's coming:

- 📜 History of transcriptions with search and export
- 🤖 Optional local LLM integration for:
  - Filler word removal ("um", "uh", "like")
  - Smart punctuation and formatting
  - Grammar improvements
- 🔄 Alternative recognition engines (whisper.cpp)
- 📚 Personal dictionary for custom words and terminology
- ⚡ Voice shortcuts and text snippets

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Documentation

- [Landing Page](index.html) - Marketing website for Murmur
- [Contributing Guidelines](CONTRIBUTING.md) - How to contribute to Murmur
- [Security Policy](SECURITY.md) - Our privacy and security principles
- [Build Documentation](BUILD.md) - Detailed build instructions
- [Scripts Reference](SCRIPTS.md) - Development scripts overview

## Acknowledgments

### Core Technology
- **Speech Framework** - Apple's native speech recognition (SFSpeechRecognizer)
- **SwiftUI** - Native macOS UI framework
- **AVFoundation** - Audio capture and processing

Built with native macOS technologies to ensure maximum privacy, performance, and reliability.

## Pricing & Support

**Murmur is free, open source, and always will be.** All features are available to everyone at no cost.

### Support Development

If you find Murmur valuable and want to support continued development:

- ❤️ **GitHub Sponsors**: [Become a sponsor](https://github.com/sponsors) (recommended)
- 💰 **Pay what feels fair**: $5 (Coffee) • $29 (Recommended) • $50 (Generous) • Your choice
- ⭐ **Star the repo**: Help others discover Murmur on GitHub
- 🐛 **Bug reports**: [Open an issue](https://github.com/bruncanepa/murmur/issues)
- 💡 **Feature requests**: [Open an issue](https://github.com/bruncanepa/murmur/issues)

**Where your support goes:**
- 60% - Development time (coding, testing, support)
- 20% - Apple Developer account & code signing
- 20% - Infrastructure (domain, CDN, tools)

See our [detailed pricing section](index.html#pricing) for more information.

### Future: Pro Features

We're planning optional Pro features (~$29 one-time) as **separate plugins**:

- 📜 **Transcription history** - Searchable archive with export to CSV/MD/TXT
- 📖 **Personal dictionary** - 10,000+ custom words and abbreviations
- 🤖 **Local AI cleanup** - Filler word removal, smart punctuation (100% offline)
- ⚡ **Voice shortcuts** - Trigger custom text snippets with voice commands
- ⚙️ **Custom hotkeys** - Fully customizable trigger keys

**The base app will always remain free and fully functional.** Pro features will be optional closed-source plugins that enhance, not replace, the open-source core. Estimated launch: Q2 2025.

Learn more about our [pricing philosophy](index.html#pricing) and why we believe privacy-first software can be sustainable without compromising values.

## License

MIT License - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2025 Bruno Cánepa

---

<div align="center">
  Made with ❤️ for privacy-conscious Mac users
  <br/>
  <sub>Because your voice is yours, and it should stay that way.</sub>
</div>
