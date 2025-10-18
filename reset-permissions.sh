#!/bin/bash

# Reset Murmur permissions in macOS TCC (Transparency, Consent, and Control) database
# Usage:
#   ./reset-permissions.sh       - Reset dev permissions (default)
#   ./reset-permissions.sh --dev - Reset dev permissions
#   ./reset-permissions.sh --prod - Reset production permissions
#   ./reset-permissions.sh --all - Reset both dev and prod permissions

set -e

# Parse mode flag
MODE="dev"
if [[ "$1" == "--prod" ]]; then
    MODE="prod"
elif [[ "$1" == "--all" ]]; then
    MODE="all"
elif [[ "$1" == "--dev" ]]; then
    MODE="dev"
fi

# Set bundle ID based on mode
if [[ "$MODE" == "all" ]]; then
    BUNDLE_IDS=("com.murmur.app.dev" "com.murmur.app")
    echo "🔐 Resetting ALL Murmur permissions (dev + prod)..."
elif [[ "$MODE" == "prod" ]]; then
    BUNDLE_IDS=("com.murmur.app")
    echo "🔐 Resetting Murmur PRODUCTION permissions..."
else
    BUNDLE_IDS=("com.murmur.app.dev")
    echo "🔐 Resetting Murmur DEVELOPMENT permissions..."
fi

# Kill the app first
echo "🛑 Stopping Murmur..."
killall Murmur 2>/dev/null || true

# Reset permissions for each bundle ID
for BUNDLE_ID in "${BUNDLE_IDS[@]}"; do
    echo ""
    echo "Resetting permissions for: $BUNDLE_ID"

    # Reset microphone permission
    echo "  🎤 Resetting microphone..."
    tccutil reset Microphone "$BUNDLE_ID" 2>/dev/null || echo "     (No existing microphone permission found)"

    # Reset accessibility permission (requires manual removal from System Settings)
    echo "  ♿ Resetting accessibility..."
    tccutil reset Accessibility "$BUNDLE_ID" 2>/dev/null || true
done

echo ""
echo "✅ Permissions reset!"
echo ""
echo "Note: You may need to manually remove apps from:"
echo "  System Settings > Privacy & Security > Accessibility"
echo ""
echo "Next steps:"
if [[ "$MODE" == "prod" ]]; then
    echo "  Run: ./run.sh --prod"
else
    echo "  Run: ./run.sh"
fi
echo ""
