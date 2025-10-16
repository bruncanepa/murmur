#!/bin/bash

# Quick rebuild and run script for Murmur

set -e

echo "🛑 Stopping Murmur..."
killall Murmur 2>/dev/null || true

echo "🗑️  Removing old build..."
rm -rf Murmur.app

echo "🔨 Building Murmur..."
./build-app.sh

echo "🚀 Launching Murmur..."
open Murmur.app

echo "✅ Done!"
