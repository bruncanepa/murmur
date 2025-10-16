# Security Policy

## Privacy and Security Principles

Murmur is designed with privacy and security as core principles:

### Data Privacy
- **No network requests**: All processing happens locally on your Mac
- **No data collection**: Zero telemetry, analytics, or tracking
- **No cloud services**: No voice data is ever sent to external servers
- **No local storage**: Transcriptions are only stored in memory during use

### Permissions
Murmur requests only essential permissions:
- **Microphone**: Required to capture your voice for transcription
- **Speech Recognition**: Required to convert speech to text using macOS APIs

### Code Transparency
- **Open Source**: All code is available for inspection
- **Verifiable**: Build from source to verify no hidden functionality
- **Minimal Dependencies**: Uses only native macOS frameworks

## Reporting Security Issues

If you discover a security vulnerability, please report it privately:

1. **Do NOT** open a public issue
2. Email: [Your contact email here]
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will respond within 48 hours and work with you to address the issue.

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Security Best Practices

### For Users
- Download only from official sources (GitHub releases)
- Verify code signatures when available
- Review permissions requested by the app
- Keep macOS updated for latest security patches

### For Contributors
- Never add network functionality
- Never add telemetry or tracking
- Never store sensitive data persistently
- Always request minimum necessary permissions
- Review all dependencies for security issues

## Third-Party Security

Murmur uses only Apple's native frameworks:
- **Speech Framework**: Apple's on-device speech recognition
- **SwiftUI**: Apple's UI framework
- **AVFoundation**: Apple's audio framework

These are maintained and secured by Apple as part of macOS.
