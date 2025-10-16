#!/bin/bash

# Quick rebuild and run script for Murmur
# Usage:
#   ./run.sh          - Full rebuild (kill, remove, build, launch)
#   ./run.sh --no-build - Just kill and launch (no rebuild)

set -e

# Check for --no-build flag
NO_BUILD=false
if [[ "$1" == "--no-build" ]]; then
    NO_BUILD=true
fi

echo "🛑 Stopping Murmur..."
killall Murmur 2>/dev/null || true

if [ "$NO_BUILD" = false ]; then
    echo "🗑️  Removing old build..."
    rm -rf Murmur.app

    echo "🔨 Building Murmur..."
    ./build-app.sh
else
    echo "⏭️  Skipping build (using existing Murmur.app)..."
fi

echo "🚀 Launching Murmur..."
open Murmur.app

echo "✅ Done!"
