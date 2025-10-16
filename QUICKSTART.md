# PWhisper - Quick Start Guide

## Running the App

### Method 1: App Bundle (Recommended)
```bash
./build-app.sh
open PWhisper.app
```

This creates a proper app with all the necessary entitlements and permissions.

### Method 2: Xcode
```bash
# Generate Xcode project
swift package generate-xcodeproj

# Open in Xcode
open PWhisper.xcodeproj
```

Then press **Cmd+R** to build and run.

## First Launch Setup

When you first launch PWhisper, macOS will request permissions:

1. **Speech Recognition Permission**
   - Click "OK" to allow
   - Required for voice transcription

2. **Microphone Access**
   - Click "OK" to allow
   - Required to capture your voice

If you accidentally denied permissions, you can enable them later in:
**System Settings → Privacy & Security → Speech Recognition / Microphone**

## How to Use

### Using the Menu Bar Interface
1. Click the **waveform icon** in your menu bar
2. **Select your language**: Choose between English or Spanish
3. Click **"Start"** to begin recording
4. Speak naturally in your selected language
5. Click **"Stop"** when done
6. Click **"Copy"** to copy text to clipboard
7. Paste anywhere with **Cmd+V**

### Using the Global Hotkey
1. Press **Cmd+Shift+Space** to start recording
2. Speak naturally
3. Press **Cmd+Shift+Space** again to stop
4. Open the menu bar popover to copy the text

## Features

- ✅ **100% Private**: All processing happens locally on your Mac
- ✅ **Real-time Transcription**: See your words appear as you speak
- ✅ **System-wide Hotkey**: Cmd+Shift+Space works anywhere
- ✅ **Multi-language**: English and Spanish support
- ✅ **Native macOS**: Uses built-in Speech Recognition framework
- ✅ **No Internet Required**: Works completely offline

## Troubleshooting

### "Speech recognition not authorized"
- Go to **System Settings → Privacy & Security → Speech Recognition**
- Enable PWhisper

### "No microphone detected"
- Check your microphone is connected
- Go to **System Settings → Privacy & Security → Microphone**
- Enable PWhisper

### Hotkey not working
- The app must be running (check for icon in menu bar)
- Try clicking the menu bar icon and using the Start/Stop buttons
- Check if another app is using Cmd+Shift+Space

### No text appearing
- Ensure microphone permissions are granted
- Speak clearly and naturally
- Check your microphone is working in System Settings

## What's Next?

This is **Phase 1** - basic speech recognition with hotkey support.

**Future phases will add**:
- Text injection into any application (no manual copy/paste)
- AI-powered post-processing (filler word removal, formatting)
- Personal dictionary and voice shortcuts
- Per-application preferences
- Multi-language support

## Privacy Note

Unlike wisprflow.ai, PWhisper:
- Never sends your voice to the cloud
- Never stores recordings
- Uses only native macOS APIs
- Keeps all data on your device
