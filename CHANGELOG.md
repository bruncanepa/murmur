# Changelog

All notable changes to Murmur will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Distribution workflow with DMG installer creation
- Version display in app UI
- Automated release process with GitHub Actions

## [1.0.0] - 2025-10-24

### Added
- **Privacy-First Voice Dictation**: Complete offline speech recognition using Apple's native Speech Recognition framework
- **Quick Dictation Mode**: Press-and-hold right ⌘ key to record, release to auto-paste into any app
- **Manual Mode**: Traditional start/stop button controls with editable transcription
- **Auto-Type Functionality**: Automatically paste transcribed text to active application
- **Multi-Language Support**: English and Portuguese language recognition
- **On-Device Recognition**: Optional fully offline mode for maximum privacy and offline use
- **Real-Time Transcription**: Live text updates while recording with automatic session management
- **Editable Transcriptions**: Edit text during or after recording before pasting
- **Continuous Recording**: Automatic session restarts for recordings longer than 60 seconds
- **Menu Bar App**: Unobtrusive status item with popover interface
- **Thread-Safe Audio**: NSLock-based thread safety for audio operations
- **Event Debouncing**: Prevents duplicate hotkey triggers with 50ms debouncing

### Technical Features
- SwiftUI interface with reactive updates
- AVAudioEngine for audio capture
- SFSpeechRecognizer for transcription
- Global hotkey monitoring with HotkeyManager
- Accessibility API integration for text input simulation
- Separate dev/prod build configurations
- Entitlements-based permission system

### Documentation
- Comprehensive README with features and usage
- BUILD.md with detailed build instructions
- CONTRIBUTING.md for contributors
- SECURITY.md outlining privacy commitment
- CLAUDE.md with AI assistant instructions
- Issue templates for bug reports and feature requests

### Requirements
- macOS 13.0 or later
- Microphone permission
- Speech Recognition permission
- Accessibility permission (for auto-type)

[Unreleased]: https://github.com/bruncanepa/murmur/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/bruncanepa/murmur/releases/tag/v1.0.0
