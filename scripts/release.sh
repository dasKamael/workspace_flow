#!/usr/bin/env bash
set -euo pipefail

APP_NAME="Loom"
APP_PATH="build/macos/Build/Products/Release/${APP_NAME}.app"
NOTARY_PROFILE="loom-notary"
DIST_DIR="dist"
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | cut -d+ -f1)

rm -rf "$DIST_DIR" && mkdir -p "$DIST_DIR"

echo "==> flutter build macos --release"
flutter build macos --release

echo "==> verifying code signature"
codesign --verify --deep --strict --verbose=2 "$APP_PATH"
codesign -dvv "$APP_PATH"

echo "==> zipping for notarization"
ZIP_PATH="$DIST_DIR/${APP_NAME}-${VERSION}.zip"
ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"

echo "==> submitting to notary service"
xcrun notarytool submit "$ZIP_PATH" --keychain-profile "$NOTARY_PROFILE" --wait

echo "==> stapling ticket"
xcrun stapler staple "$APP_PATH"
xcrun stapler validate "$APP_PATH"

echo "==> building dmg"
DMG_PATH="$DIST_DIR/${APP_NAME}-${VERSION}.dmg"
hdiutil create -volname "$APP_NAME" -srcfolder "$APP_PATH" -ov -format UDZO "$DMG_PATH"

echo "==> re-zipping the notarized app for direct-zip distribution"
ditto -c -k --keepParent "$APP_PATH" "$DIST_DIR/${APP_NAME}-${VERSION}-notarized.zip"

echo "==> gatekeeper check"
spctl -a -vv --type execute "$APP_PATH"

echo "Done. Artifacts in $DIST_DIR/"
