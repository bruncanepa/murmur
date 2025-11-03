#!/bin/bash

# Create DMG installer for Murmur
# This script creates a distributable DMG file from the built Murmur.app
#
# Usage:
#   ./create-dmg-installer.sh              - Create DMG from Murmur.app
#   ./create-dmg-installer.sh --version 1.0.0  - Specify version for DMG name

set -e

# Default values
APP_NAME="Murmur.app"
VERSION=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --version)
            VERSION="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--version VERSION]"
            exit 1
            ;;
    esac
done

# Check if app exists
if [[ ! -d "$APP_NAME" ]]; then
    echo "❌ Error: $APP_NAME not found"
    echo "Run ./build-app.sh --prod first"
    exit 1
fi

# Extract version from Info.plist if not provided
if [[ -z "$VERSION" ]]; then
    VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$APP_NAME/Contents/Info.plist" 2>/dev/null || echo "1.0.0")
fi

DMG_NAME="Murmur-${VERSION}.dmg"
TEMP_DIR=$(mktemp -d)
STAGING_DIR="$TEMP_DIR/Murmur"

echo "📦 Creating DMG installer..."
echo "   App: $APP_NAME"
echo "   Version: $VERSION"
echo "   Output: $DMG_NAME"
echo ""

# Create staging directory
mkdir -p "$STAGING_DIR"

# Copy app to staging
echo "Copying app to staging directory..."
cp -R "$APP_NAME" "$STAGING_DIR/"

# Create Applications symlink for easy installation
echo "Creating Applications symlink..."
ln -s /Applications "$STAGING_DIR/Applications"

# Remove old DMG if exists
rm -f "$DMG_NAME"
TEMP_DMG="$TEMP_DIR/temp.dmg"

# Create temporary writable DMG
echo "Creating temporary DMG..."
hdiutil create -volname "Murmur" \
    -srcfolder "$STAGING_DIR" \
    -ov \
    -format UDRW \
    -fs HFS+ \
    "$TEMP_DMG"

# Mount the DMG
echo "Mounting DMG to customize..."
MOUNT_DIR=$(hdiutil attach "$TEMP_DMG" | grep -o '/Volumes/.*$')

# Wait for mount
sleep 2

# Set custom icon for the volume if icon file exists
if [[ -f "Assets/AppIcon.icns" ]]; then
    echo "Setting custom volume icon..."
    cp Assets/AppIcon.icns "$MOUNT_DIR/.VolumeIcon.icns"
    SetFile -c icnC "$MOUNT_DIR/.VolumeIcon.icns"
    SetFile -a C "$MOUNT_DIR"
fi

# Try to set window appearance using AppleScript (may require permissions)
echo "Configuring DMG window appearance..."
osascript <<EOF 2>/dev/null || echo "  Note: Window customization skipped (Finder automation not authorized)"
tell application "Finder"
    tell disk "Murmur"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set bounds of container window to {400, 200, 900, 500}
        set viewOptions to icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 100
        set position of item "Murmur.app" of container window to {125, 150}
        set position of item "Applications" of container window to {375, 150}
        update without registering applications
        delay 2
        close
    end tell
end tell
EOF

# Unmount
echo "Unmounting DMG..."
hdiutil detach "$MOUNT_DIR" -quiet 2>/dev/null || hdiutil detach "$MOUNT_DIR" -force

# Convert to compressed read-only DMG
echo "Compressing final DMG..."
hdiutil convert "$TEMP_DMG" \
    -format UDZO \
    -o "$DMG_NAME"

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "✅ DMG created successfully!"
echo ""
echo "📦 $DMG_NAME"
echo ""
echo "To install:"
echo "  1. Open $DMG_NAME"
echo "  2. Drag Murmur.app to Applications folder"
echo "  3. Right-click Murmur.app in Applications and select 'Open' (first time only)"
echo ""
echo "To test:"
echo "  open $DMG_NAME"
echo ""
