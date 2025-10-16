#!/bin/bash

# Build PWhisper macOS app bundle with proper entitlements

set -e

echo "Building PWhisper..."

# Clean previous builds
rm -rf .build/release
rm -rf PWhisper.app

# Build the binary
swift build -c release

# Create app bundle structure
echo "Creating app bundle..."
mkdir -p PWhisper.app/Contents/MacOS
mkdir -p PWhisper.app/Contents/Resources

# Copy binary
cp .build/release/PWhisper PWhisper.app/Contents/MacOS/

# Create Info.plist
cat > PWhisper.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>PWhisper</string>
    <key>CFBundleIdentifier</key>
    <string>com.pwhisper.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>PWhisper</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSMicrophoneUsageDescription</key>
    <string>PWhisper needs access to your microphone to transcribe your speech.</string>
    <key>NSSpeechRecognitionUsageDescription</key>
    <string>PWhisper uses speech recognition to convert your voice to text.</string>
    <key>NSUserNotificationsUsageDescription</key>
    <string>PWhisper sends notifications when text is copied to clipboard.</string>
</dict>
</plist>
EOF

# Sign the app with entitlements
echo "Signing app..."
codesign --force --deep --sign - --entitlements PWhisper.entitlements PWhisper.app

echo ""
echo "✅ Build complete!"
echo ""
echo "To run the app:"
echo "  open PWhisper.app"
echo ""
echo "To install to Applications:"
echo "  cp -r PWhisper.app /Applications/"
echo ""
