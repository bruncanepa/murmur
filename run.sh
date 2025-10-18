#!/bin/bash

# Quick rebuild and run script for Murmur
# Usage:
#   ./run.sh              - Quick rebuild in dev mode (kill, build, launch) - DEFAULT
#   ./run.sh --prod       - Build and run in production mode
#   ./run.sh --force      - Full clean rebuild (kill, remove, build, launch)
#   ./run.sh --no-build   - Just restart (kill, launch, no rebuild)

set -e

# Parse flags
CLEAN_BUILD=false
NO_BUILD=false
MODE="dev"

for arg in "$@"; do
    case $arg in
        --force)
            CLEAN_BUILD=true
            ;;
        --no-build)
            NO_BUILD=true
            ;;
        --prod)
            MODE="prod"
            ;;
        --dev)
            MODE="dev"
            ;;
    esac
done

# Set app name based on mode
if [[ "$MODE" == "prod" ]]; then
    APP_NAME="Murmur.app"
else
    APP_NAME="Murmur-Dev.app"
fi

echo "🛑 Stopping Murmur..."
killall Murmur 2>/dev/null || true

if [ "$NO_BUILD" = false ]; then
    if [ "$CLEAN_BUILD" = true ]; then
        echo "🗑️  Cleaning build cache..."
        if [[ "$MODE" == "prod" ]]; then
            rm -rf .build/release
        else
            rm -rf .build/debug
        fi
        rm -rf "$APP_NAME"

        echo "🔨 Building Murmur (clean, $MODE mode)..."
        ./build-app.sh --$MODE
    else
        echo "⚡ Building Murmur (incremental, $MODE mode)..."
        ./build-app.sh --$MODE
    fi
else
    echo "⏭️  Skipping build (using existing $APP_NAME)..."
fi

echo "🚀 Launching $APP_NAME..."
open "$APP_NAME"

echo "✅ Done!"
