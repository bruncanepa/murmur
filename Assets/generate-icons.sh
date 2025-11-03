#!/bin/bash

# Generate PNG icons from SVG at all required macOS sizes
# Uses rsvg-convert (from librsvg) for high-quality SVG rendering

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SVG_FILE="$SCRIPT_DIR/AppIcon.svg"
OUTPUT_DIR="$SCRIPT_DIR/AppIcon.appiconset"

echo "🎨 Generating app icons from SVG..."
echo "Source: $SVG_FILE"
echo "Output: $OUTPUT_DIR"
echo ""

# Check if we need to install rsvg-convert
if ! command -v rsvg-convert &> /dev/null; then
    echo "📦 rsvg-convert not found. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew not found. Please install Homebrew first:"
        echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    brew install librsvg
fi

# Function to convert SVG to PNG at specific size
generate_icon() {
    local size=$1
    local scale=$2
    local filename=$3

    local pixel_size=$((size * scale))

    echo "  Generating ${filename} (${pixel_size}x${pixel_size}px)..."

    rsvg-convert -w ${pixel_size} -h ${pixel_size} "$SVG_FILE" > "$OUTPUT_DIR/$filename"
}

# Generate all required sizes for macOS
generate_icon 16 1 "icon_16x16.png"
generate_icon 16 2 "icon_16x16@2x.png"
generate_icon 32 1 "icon_32x32.png"
generate_icon 32 2 "icon_32x32@2x.png"
generate_icon 128 1 "icon_128x128.png"
generate_icon 128 2 "icon_128x128@2x.png"
generate_icon 256 1 "icon_256x256.png"
generate_icon 256 2 "icon_256x256@2x.png"
generate_icon 512 1 "icon_512x512.png"
generate_icon 512 2 "icon_512x512@2x.png"

echo ""
echo "✅ Icon generation complete!"
echo ""
echo "📁 Icons saved to: $OUTPUT_DIR"
echo ""
echo "Next steps:"
echo "  1. Review the generated icons: open $OUTPUT_DIR"
echo "  2. Add AppIcon.appiconset to your Xcode project"
echo "  3. Update build-app.sh to include the new icon"
echo ""
