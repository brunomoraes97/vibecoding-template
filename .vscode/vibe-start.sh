#!/bin/bash

# 0. DETECTIVE MODE: Find where the project is hiding
# If package.json is NOT in the current folder, let's look inside subfolders.
if [ ! -f "package.json" ]; then
    # Finds the first package.json inside immediate subfolders (maxdepth 2)
    # ignoring node_modules to avoid false positives.
    PROJECT_PATH=$(find . -maxdepth 2 -name "package.json" -not -path "*/node_modules/*" | head -n 1)

    if [ -n "$PROJECT_PATH" ]; then
        # Extract just the directory name (e.g., "./adremix_final")
        TARGET_DIR=$(dirname "$PROJECT_PATH")
        
        echo "📂 Project detected inside: $TARGET_DIR"
        echo "➡️  Switching to project directory..."
        
        # Move into that directory
        cd "$TARGET_DIR"
    fi
fi

# ========================================================
# From here on, it's the same logic, but now we are in the right place
# ========================================================

# 1. CHECK: Does package.json exist (now)?
if [ ! -f "package.json" ]; then
    echo ""
    echo "========================================================"
    echo "🔴 STOP: No project files detected."
    echo "👉 Please drag and drop your project folder here."
    echo "   Ensure 'package.json' is present."
    echo "========================================================"
    echo ""
    read -p "Press [Enter] to close this warning..."
    exit 0
fi

# 2. CHECK: Are dependencies installed?
if [ ! -d "node_modules" ]; then
    echo "📦 Dependencies missing. Installing now..."
    npm install
fi

# 3. ACTION: Start the engine
echo "🚀 Starting Vibe Coding Environment..."

if grep -q "\"dev\":" "package.json"; then
    npm run dev
elif grep -q "\"start\":" "package.json"; then
    npm start
else
    echo "❌ Error: No 'dev' or 'start' script found in package.json"
    read -p "Press [Enter] to exit..."
    exit 1
fi