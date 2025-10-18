# Build & Development Guide

## Quick Start

**Development (default):**
```bash
./dev.sh                # Shortcut for development mode
# or
./run.sh                # Same as above (dev is default)
```

**Production:**
```bash
./prod.sh               # Shortcut for production mode
# or
./run.sh --prod         # Same as above
```

## Build Modes

### Development Mode (Default)
- **App Name:** `Murmur-Dev.app`
- **Bundle ID:** `com.murmur.app.dev`
- **Build Config:** Debug (faster builds, includes debug symbols)
- **Purpose:** Daily development work
- **Benefit:** Permissions persist across rebuilds!

### Production Mode
- **App Name:** `Murmur.app`
- **Bundle ID:** `com.murmur.app`
- **Build Config:** Release (optimized, no debug symbols)
- **Purpose:** Final builds for distribution
- **Benefit:** Clean, optimized binary for end users

## Commands

### Building

```bash
# Development builds (default)
./build-app.sh              # Build in dev mode
./build-app.sh --dev        # Build in dev mode (explicit)

# Production builds
./build-app.sh --prod       # Build in production mode
```

### Running

```bash
# Simple shortcuts
./dev.sh                    # Development mode (default)
./prod.sh                   # Production mode

# With additional options
./dev.sh --force            # Clean dev build
./dev.sh --no-build         # Restart dev without rebuilding
./prod.sh --force           # Clean prod build

# Or use run.sh directly
./run.sh                    # Dev mode (default)
./run.sh --dev              # Dev mode (explicit)
./run.sh --prod             # Production mode
./run.sh --force            # Full clean rebuild
./run.sh --no-build         # Just restart without rebuilding
./run.sh --prod --force     # Clean prod build
```

### Resetting Permissions

```bash
# Reset dev permissions (default)
./reset-permissions.sh

# Reset production permissions
./reset-permissions.sh --prod

# Reset both dev and prod
./reset-permissions.sh --all
```

## First Time Setup

1. **Build the dev version:**
   ```bash
   ./dev.sh
   ```

2. **Grant permissions when prompted:**
   - Microphone access
   - Accessibility access (for auto-typing)

3. **Permissions will now persist!**
   - No need to re-grant on every rebuild
   - Both dev and prod can coexist with separate permissions

## Common Workflows

**Daily development:**
```bash
./dev.sh                    # Quick rebuild and run
```

**Clean rebuild (if having issues):**
```bash
./dev.sh --force
```

**Just restart (no rebuild):**
```bash
./dev.sh --no-build
```

**Build for distribution:**
```bash
./prod.sh
```

## Why Two Versions?

**Development (`Murmur-Dev.app`):**
- Fast debug builds
- Permissions persist across rebuilds
- Can run alongside production version
- Separate settings/preferences

**Production (`Murmur.app`):**
- Optimized release builds
- Clean for distribution
- Separate permission profile
- Ready for App Store or sharing

## Troubleshooting

### Permissions Asked on Every Build

If you still get permission prompts on every rebuild:

1. **Reset permissions:**
   ```bash
   ./reset-permissions.sh
   ```

2. **Remove from System Settings manually:**
   - Go to: System Settings > Privacy & Security > Accessibility
   - Find and remove any "Murmur" or "Murmur-Dev" entries

3. **Clean rebuild:**
   ```bash
   ./run.sh --force
   ```

4. **Grant permissions fresh**

### Both Versions Running

To run both dev and prod simultaneously:
```bash
# Terminal 1
./run.sh --dev

# Terminal 2
./run.sh --prod
```

They have separate bundle IDs and won't conflict!

## Installation

**Development:** Just use `./run.sh` (no installation needed)

**Production:**
```bash
./build-app.sh --prod
cp -r Murmur.app /Applications/
```

## Technical Details

### Bundle Identifiers
- **Dev:** `com.murmur.app.dev`
- **Prod:** `com.murmur.app`

### Code Signing
Both versions use ad-hoc signing with stable identifiers:
```bash
codesign --force --deep --sign - --identifier <BUNDLE_ID> <APP_NAME>
```

This ensures macOS recognizes the same app across rebuilds, preserving permissions.

### Build Configurations
- **Debug:** Fast incremental builds, includes debug symbols
- **Release:** Full optimizations, stripped binaries
