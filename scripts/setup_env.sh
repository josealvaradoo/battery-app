#!/bin/bash

# Script to setup environment variables for iOS build
# Usage: ./scripts/setup_env.sh

# Check if GOOGLE_CLIENT_ID is provided via dart-define
if [ -z "$GOOGLE_CLIENT_ID" ]; then
  echo "Error: GOOGLE_CLIENT_ID not found in dart-define"
  echo "Usage: flutter run --dart-define=GOOGLE_CLIENT_ID=your_client_id"
  exit 1
fi

# Generate REVERSED_CLIENT_ID from GOOGLE_CLIENT_ID
REVERSED_CLIENT_ID="com.googleusercontent.apps.${GOOGLE_CLIENT_ID}"

# Set Xcode environment variables
echo "Setting up iOS environment variables..."
echo "GOOGLE_CLIENT_ID = $GOOGLE_CLIENT_ID"
echo "REVERSED_CLIENT_ID = $REVERSED_CLIENT_ID"

# Export for Xcode build
export GOOGLE_CLIENT_ID
export REVERSED_CLIENT_ID

echo "Environment setup complete!"
