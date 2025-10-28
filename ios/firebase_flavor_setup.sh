#!/bin/bash

# Exit immediately if a command fails
set -e

# Read the FLAVOR variable from Flavor.xcconfig
FLAVOR=$(grep FLAVOR ios/Flavor.xcconfig | cut -d '=' -f2 | xargs)

echo "🔧 Configuring Firebase for flavor: $FLAVOR"

if [ "$FLAVOR" == "development" ]; then
    PLIST="Runner/Firebase/development/GoogleService-Info.plist"
elif [ "$FLAVOR" == "production" ]; then
    PLIST="Runner/Firebase/production/GoogleService-Info.plist"
else
    echo "Unknown flavor: $FLAVOR"
    exit 1
fi

# Copy the correct plist into the Runner folder for the build
cp "ios/$PLIST" "ios/Runner/GoogleService-Info.plist"

echo "Firebase config copied successfully from: $PLIST"
