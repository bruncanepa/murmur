#!/bin/bash

# Build Murmur macOS app bundle with proper entitlements

set -e

echo "Building Murmur..."

# Clean previous builds
rm -rf .build/release
rm -rf Murmur.app

# Build the binary
swift build -c release

# Create app bundle structure
echo "Creating app bundle..."
mkdir -p Murmur.app/Contents/MacOS
mkdir -p Murmur.app/Contents/Resources

# Copy binary
cp .build/release/Murmur Murmur.app/Contents/MacOS/

# Create Info.plist
cat > Murmur.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>Murmur</string>
    <key>CFBundleIdentifier</key>
    <string>com.murmur.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Murmur</string>
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
    <string>Murmur needs access to your microphone to transcribe your speech.</string>
    <key>NSSpeechRecognitionUsageDescription</key>
    <string>Murmur uses speech recognition to convert your voice to text.</string>
    <key>NSUserNotificationsUsageDescription</key>
    <string>Murmur sends notifications when text is copied to clipboard.</string>
</dict>
</plist>
EOF

# Sign the app with entitlements
echo "Signing app..."
codesign --force --deep --sign - --entitlements Murmur.entitlements Murmur.app

echo ""
echo "✅ Build complete!"
echo ""
echo "To run the app:"
echo "  open Murmur.app"
echo ""
echo "To install to Applications:"
echo "  cp -r Murmur.app /Applications/"
echo ""
