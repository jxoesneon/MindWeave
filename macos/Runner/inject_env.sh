#!/bin/bash
# Build script to inject .env values into macOS Info.plist
# Place this in macos/Runner/ and reference it in Xcode build phases

set -e

# Get the project root (parent of macos directory)
# Script is at: macos/Runner/inject_env.sh
# Need to go up 2 levels to get to project root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
INFO_PLIST="$SCRIPT_DIR/../Runner/Info.plist"

# Check if .env exists
if [ ! -f "$ENV_FILE" ]; then
    echo "⚠️  .env file not found at $ENV_FILE"
    echo "Skipping Info.plist injection"
    exit 0
fi

# Function to get value from .env
get_env_value() {
    local key=$1
    local value=$(grep "^${key}=" "$ENV_FILE" | cut -d '=' -f2- | tr -d '"' | tr -d "'")
    echo "$value"
}

# Get Google Client ID - prefer macOS-specific, fall back to iOS
GOOGLE_CLIENT_ID=$(get_env_value "GOOGLE_MACOS_CLIENT_ID")
if [ -z "$GOOGLE_CLIENT_ID" ] || [ "$GOOGLE_CLIENT_ID" = "" ]; then
    GOOGLE_CLIENT_ID=$(get_env_value "GOOGLE_IOS_CLIENT_ID")
fi

if [ -z "$GOOGLE_CLIENT_ID" ] || [ "$GOOGLE_CLIENT_ID" = "" ]; then
    echo "⚠️  No Google Client ID found in .env (GOOGLE_MACOS_CLIENT_ID or GOOGLE_IOS_CLIENT_ID)"
    exit 0
fi

echo "🔧 Injecting Google Client ID into Info.plist..."

# Create URL scheme from Client ID
# Client ID format: [ID].apps.googleusercontent.com
# URL scheme format: com.googleusercontent.apps.[ID]
URL_SCHEME="com.googleusercontent.apps.${GOOGLE_CLIENT_ID%.apps.googleusercontent.com}"

# Backup original plist if not already backed up
if [ ! -f "$INFO_PLIST.backup" ]; then
    cp "$INFO_PLIST" "$INFO_PLIST.backup"
fi

# Use sed to replace placeholders
# Replace GIDClientID value
sed -i '' "s|<string>YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com</string>|<string>$GOOGLE_CLIENT_ID</string>|g" "$INFO_PLIST"

# Replace URL scheme
sed -i '' "s|<string>com.googleusercontent.apps.YOUR_GOOGLE_CLIENT_ID</string>|<string>$URL_SCHEME</string>|g" "$INFO_PLIST"

echo "✅ Info.plist updated with Google Client ID"
echo "   GIDClientID: $GOOGLE_CLIENT_ID"
echo "   URL Scheme: $URL_SCHEME"
