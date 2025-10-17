#!/bin/bash

# Quick rebuild and run script for Murmur
# Usage:
#   ./run.sh            - Quick rebuild (kill, build, launch) - DEFAULT
#   ./run.sh --force    - Full clean rebuild (kill, remove, build, launch)
#   ./run.sh --no-build - Just restart (kill, launch, no rebuild)

set -e

# Parse flags
CLEAN_BUILD=false
NO_BUILD=false

if [[ "$1" == "--force" ]]; then
    CLEAN_BUILD=true
elif [[ "$1" == "--no-build" ]]; then
    NO_BUILD=true
fi

echo "🛑 Stopping Murmur..."
killall Murmur 2>/dev/null || true

if [ "$NO_BUILD" = false ]; then
    if [ "$CLEAN_BUILD" = true ]; then
        echo "🗑️  Removing old build..."
        rm -rf Murmur.app

        echo "🔨 Building Murmur (clean)..."
        ./build-app.sh
    else
        echo "⚡ Building Murmur (quick rebuild)..."
        ./build-app.sh
    fi
else
    echo "⏭️  Skipping build (using existing Murmur.app)..."
fi

echo "🚀 Launching Murmur..."
open Murmur.app

echo "✅ Done!"
