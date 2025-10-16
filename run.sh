#!/bin/bash

# Quick rebuild and run script for PWhisper

set -e

echo "🛑 Stopping PWhisper..."
killall PWhisper 2>/dev/null || true

echo "🗑️  Removing old build..."
rm -rf PWhisper.app

echo "🔨 Building PWhisper..."
./build-app.sh

echo "🚀 Launching PWhisper..."
open PWhisper.app

echo "✅ Done!"
