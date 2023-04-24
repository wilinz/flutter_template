#!/bin/sh
brew install create-dmg
test -f flutter_template.dmg && rm flutter_template.dmg
create-dmg \
  --volname "Flutter Template" \
  --volicon "./AppIcon.icns" \
  --window-pos 200 120 \
  --window-size 800 500 \
  --icon-size 100 \
  --icon "flutter_template.app" 200 190 \
  --hide-extension "flutter_template.app" \
  --app-drop-link 600 185 \
  "flutter_template.dmg" \
  "../build/macos/Build/Products/Release/flutter_template.app"

