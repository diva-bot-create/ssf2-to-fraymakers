#!/usr/bin/env bash
set -e

REPO="$(cd "$(dirname "$0")" && pwd)"
APP="$REPO/SSF2ConverterApp/build/SSF2ConverterApp.app"

echo "→ Building Rust converter..."
cd "$REPO"
cargo build --release

echo "→ Building Swift UI..."
cd "$REPO/SSF2ConverterApp"
swift build -c release

echo "→ Assembling .app bundle..."
mkdir -p "$APP/Contents/MacOS"
mkdir -p "$APP/Contents/Resources"

cp .build/release/SSF2ConverterApp "$APP/Contents/MacOS/"
cp "$REPO/target/release/ssf2_converter" "$APP/Contents/MacOS/"

cat > "$APP/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>SSF2ConverterApp</string>
    <key>CFBundleIdentifier</key>
    <string>com.ssf2converter.app</string>
    <key>CFBundleName</key>
    <string>SSF2 Converter</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSUIElement</key>
    <false/>
    <key>NSSupportsAutomaticTermination</key>
    <false/>
    <key>CFBundleDocumentTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeName</key>
            <string>SSF File</string>
            <key>CFBundleTypeExtensions</key>
            <array><string>ssf</string></array>
            <key>CFBundleTypeRole</key>
            <string>Viewer</string>
        </dict>
    </array>
</dict>
</plist>
PLIST

echo "→ Launching..."
pkill -f SSF2ConverterAp 2>/dev/null || true
sleep 0.3
open "$APP" &
disown

echo "✓ Done — SSF2 Converter is running"
exit 0
