# Contributing to Murmur

Thank you for your interest in contributing to Murmur! This document provides guidelines for contributing to the project.

## Code of Conduct

Be respectful, inclusive, and constructive in all interactions.

## How to Contribute

### Reporting Bugs

Before creating a bug report, please check existing issues to avoid duplicates.

When filing a bug report, include:
- **Clear title and description**
- **Steps to reproduce** the behavior
- **Expected behavior** vs actual behavior
- **macOS version** and hardware details
- **Screenshots** if applicable
- **Error messages** or logs

### Suggesting Enhancements

Enhancement suggestions are welcome! Please include:
- **Clear use case** - why is this enhancement useful?
- **Proposed solution** - how would it work?
- **Alternative solutions** considered
- **Impact on privacy** - does it maintain local-only processing?

### Pull Requests

1. **Fork** the repository
2. **Create a branch** for your feature (`git checkout -b feature/amazing-feature`)
3. **Make your changes**
   - Follow existing code style
   - Add tests if applicable
   - Update documentation as needed
4. **Test thoroughly** on your local machine
5. **Commit** with clear messages (`git commit -m 'Add amazing feature'`)
6. **Push** to your branch (`git push origin feature/amazing-feature`)
7. **Open a Pull Request**

### Code Style

- Follow Swift conventions and best practices
- Use clear, descriptive variable and function names
- Add comments for complex logic
- Keep functions focused and concise

### Testing

Before submitting a PR:
- Test on macOS 13.0+ (Ventura or later)
- Verify microphone and speech recognition permissions work
- Test both English and Spanish language modes
- Ensure the Clear button properly restarts recording
- Check that the app builds with `./run.sh`

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/murmur.git
cd murmur

# Build and run
./run.sh
```

## Project Structure

```
murmur/
├── Sources/
│   ├── MurmurApp.swift       # App entry point
│   ├── AppDelegate.swift     # Menu bar and hotkey setup
│   ├── ContentView.swift     # Main UI
│   ├── SpeechRecognizer.swift # Speech recognition engine
│   └── HotkeyManager.swift   # Global hotkey handler
├── build-app.sh              # Build script
├── run.sh                    # Quick build & run
└── README.md                 # Documentation
```

## Privacy First

**Critical**: All contributions must maintain the core privacy principle:
- ✅ All processing must happen locally
- ✅ No network requests (except for checking updates, if implemented)
- ✅ No telemetry or tracking
- ✅ No cloud services
- ❌ No sending voice data anywhere
- ❌ No storing recordings

## Questions?

Open an issue with the `question` label if you need help or clarification.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
