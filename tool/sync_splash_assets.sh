#!/usr/bin/env bash
# Regenerate *splash / launch-screen* bitmaps only from
# assets/branding/splash_logo.png. Does not touch launcher icons (iOS AppIcon
# or Android @mipmap/platrare). Run from repo root:
#   bash tool/sync_splash_assets.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${ROOT}/assets/branding/splash_logo.png"
if [[ ! -f "$SRC" ]]; then
  echo "Missing $SRC" >&2
  exit 1
fi

LAUNCH="${ROOT}/ios/Runner/Assets.xcassets/LaunchImage.imageset"
ANDROID_SPLASH="${ROOT}/android/app/src/main/res/drawable-nodpi/splash_center.png"

echo "→ iOS LaunchImage.imageset"
sips -z 220 220 "$SRC" --out "${LAUNCH}/LaunchImage.png" >/dev/null
sips -z 440 440 "$SRC" --out "${LAUNCH}/LaunchImage@2x.png" >/dev/null
sips -z 660 660 "$SRC" --out "${LAUNCH}/LaunchImage@3x.png" >/dev/null

echo "→ Android drawable-nodpi/splash_center.png (launch window only)"
mkdir -p "$(dirname "$ANDROID_SPLASH")"
cp "$SRC" "$ANDROID_SPLASH"

echo "Done. Flutter splash still loads assets/branding/splash_logo.png in Dart."
