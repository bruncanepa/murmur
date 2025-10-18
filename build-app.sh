#!/bin/bash

# Build Murmur macOS app bundle with proper entitlements
# Usage:
#   ./build-app.sh           - Build in development mode (default)
#   ./build-app.sh --dev     - Build in development mode
#   ./build-app.sh --prod    - Build in production mode

set -e

# Parse mode flag
MODE="dev"
if [[ "$1" == "--prod" ]]; then
    MODE="prod"
elif [[ "$1" == "--dev" ]]; then
    MODE="dev"
fi

# Set variables based on mode
if [[ "$MODE" == "prod" ]]; then
    APP_NAME="Murmur.app"
    BUNDLE_ID="com.murmur.app"
    BUILD_CONFIG="release"
    echo "🚀 Building Murmur (PRODUCTION mode)..."
else
    APP_NAME="Murmur-Dev.app"
    BUNDLE_ID="com.murmur.app.dev"
    BUILD_CONFIG="debug"
    echo "🔧 Building Murmur (DEVELOPMENT mode)..."
fi

# Remove old app bundle (but keep .build for incremental compilation)
rm -rf "$APP_NAME"

# Build the binary
echo "Building binary ($BUILD_CONFIG)..."
swift build -c $BUILD_CONFIG

# Create app bundle structure
echo "Creating app bundle..."
mkdir -p "$APP_NAME/Contents/MacOS"
mkdir -p "$APP_NAME/Contents/Resources"

# Copy binary
cp .build/$BUILD_CONFIG/Murmur "$APP_NAME/Contents/MacOS/"

# Create Info.plist with dynamic values
cat > "$APP_NAME/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>Murmur</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
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

# Sign the app with entitlements using a stable identifier
# This ensures macOS recognizes it as the same app across rebuilds
echo "Signing app with identifier: $BUNDLE_ID..."
codesign --force --deep --sign - --identifier "$BUNDLE_ID" --entitlements Murmur.entitlements "$APP_NAME"

echo ""
echo "✅ Build complete!"
echo ""
echo "App: $APP_NAME"
echo "Bundle ID: $BUNDLE_ID"
echo "Build Config: $BUILD_CONFIG"
echo ""
echo "To run the app:"
echo "  open $APP_NAME"
echo ""
if [[ "$MODE" == "prod" ]]; then
    echo "To install to Applications:"
    echo "  cp -r $APP_NAME /Applications/"
    echo ""
fi
