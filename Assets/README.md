# Murmur App Icons

Professional app icons for Murmur, combining privacy (shield/lock) with voice (waveform) elements.

## Icon Files

### Main App Icon
- **AppIcon.svg** - Primary design: Shield with sound wave and lock
- **AppIcon.appiconset/** - PNG icons at all required macOS sizes (16x16 to 1024x1024)

### Menu Bar Icon
- **MenuBarIcon.svg** - Simple waveform for macOS menu bar (template mode, renders in system colors)

### Alternative Designs
Explore different visual approaches:
- **AppIcon-Alt1-MicLock.svg** - Microphone with lock overlay
- **AppIcon-Alt2-WaveCircle.svg** - Circular waveform with privacy badge
- **AppIcon-Alt3-AbstractWave.svg** - Flowing "murmur" sound waves

## Quick Start

### Generate PNG Icons from SVG

```bash
cd Assets
./generate-icons.sh
```

This creates all required PNG sizes in `AppIcon.appiconset/`.

### Install in Xcode Project

1. **Add to Xcode:**
   - Open your Xcode project
   - Drag `AppIcon.appiconset` into your project's Assets catalog
   - Or copy to `YourProject.xcassets/`

2. **Reference in Info.plist:**
   ```xml
   <key>CFBundleIconFile</key>
   <string>AppIcon</string>
   ```

3. **Clean and rebuild:**
   ```bash
   rm -rf .build/
   ./build-app.sh --prod
   ```

### Update Menu Bar Icon

Edit `Sources/AppDelegate.swift`:

```swift
func setupStatusItem() {
    if let button = statusItem.button {
        // Use template image (renders in system color)
        if let image = NSImage(named: "MenuBarIcon") {
            image.isTemplate = true
            button.image = image
        }
    }
}
```

Add `MenuBarIcon.svg` to your Xcode Assets catalog.

## Icon Design Details

### Primary Design (AppIcon.svg)
**Concept:** Shield with sound wave and lock

**Elements:**
- **Shield shape** - Represents security and protection
- **Sound wave bars** - 5 bars showing audio/voice input
- **Lock symbol** - Bottom of shield emphasizes privacy
- **Gradient** - Purple to violet (#667eea → #764ba2) matching landing page

**Rationale:**
- Instantly communicates "private voice" concept
- Distinctive silhouette recognizable at all sizes
- Professional macOS Big Sur style with depth and shadows

### Menu Bar Icon (MenuBarIcon.svg)
**Concept:** Simple 5-bar waveform

**Design:**
- Monochrome black shapes (auto-converts to system color)
- Template mode for light/dark mode adaptation
- Optimized for 16x16px display (menu bar standard)
- No gradients or complex details (clarity at small size)

## Design Principles

### Followed macOS Guidelines
✅ **Big Sur Style:** Rounded square with subtle depth and shadows
✅ **Gradient:** Modern gradient aesthetic for app icon
✅ **Template Mode:** Monochrome menu bar icon adapts to system theme
✅ **Scalability:** Clear and legible at all sizes (16px to 1024px)
✅ **Distinctive:** Unique silhouette recognizable in Dock and app switcher

### Color Scheme
- **Primary Gradient:** #667eea (purple) → #764ba2 (violet)
- **Accent:** White with varying opacity for depth
- **Menu Bar:** Template black (system converts to menu bar color)

## Icon Specifications

### Required macOS Sizes
| Size | 1x | 2x |
|------|----|----|
| 16x16 | 16px | 32px |
| 32x32 | 32px | 64px |
| 128x128 | 128px | 256px |
| 256x256 | 256px | 512px |
| 512x512 | 512px | 1024px |

All sizes are generated automatically by `generate-icons.sh`.

### File Formats
- **SVG:** Master source files (editable, scalable)
- **PNG:** Rasterized at exact sizes for macOS (.icns bundle)

## Customization

### Changing Colors

Edit the gradient in SVG files:

```xml
<linearGradient id="primaryGradient">
  <stop offset="0%" style="stop-color:#667eea"/> <!-- Start color -->
  <stop offset="100%" style="stop-color:#764ba2"/> <!-- End color -->
</linearGradient>
```

### Switching Designs

To use an alternative design:

1. Copy alternative SVG to `AppIcon.svg`:
   ```bash
   cp AppIcon-Alt1-MicLock.svg AppIcon.svg
   ```

2. Regenerate PNGs:
   ```bash
   ./generate-icons.sh
   ```

3. Clean and rebuild app

### Creating Custom Designs

Use SVG editor (Inkscape, Figma, Sketch):
- Canvas size: 1024x1024
- Background: Rounded square (rx="180" for macOS style)
- Export as SVG
- Run `generate-icons.sh` to create PNGs

## Tools

### Required
- **rsvg-convert** (librsvg) - SVG to PNG conversion
  ```bash
  brew install librsvg
  ```

### Optional
- **Inkscape** - SVG editing
- **Figma** - Design tool
- **SF Symbols** - Apple's system icons for reference

## Troubleshooting

### Icons not updating after rebuild
**Solution:** Clear build artifacts completely
```bash
rm -rf .build/
rm -rf ~/Library/Developer/Xcode/DerivedData/Murmur-*
./build-app.sh --prod --force
```

### Icons appear blurry
**Cause:** Using 1x images on Retina displays
**Solution:** Ensure @2x images are generated and included

### Menu bar icon wrong color
**Cause:** Template mode not enabled
**Solution:** Set `image.isTemplate = true` in code

### SVG not rendering correctly
**Cause:** Complex SVG features not supported by rsvg-convert
**Solution:** Simplify SVG (avoid filters, complex paths, embedded fonts)

## Credits

**Design:** Created for Murmur privacy-first voice dictation
**Tools:** librsvg, macOS native frameworks
**Style:** macOS Big Sur icon design guidelines

## License

MIT License - Same as Murmur project

---

**Need help?** Open an issue at [github.com/bruncanepa/murmur/issues](https://github.com/bruncanepa/murmur/issues)
