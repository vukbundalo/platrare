#!/usr/bin/env bash
# Regenerate native launcher + iOS launch images from `assets/branding/splash_logo.png`.
# Run from repo root: bash tool/sync_branding_icons.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${ROOT}/assets/branding/splash_logo.png"
if [[ ! -f "$SRC" ]]; then
  echo "Missing $SRC" >&2
  exit 1
fi

ICONSET="${ROOT}/ios/Runner/Assets.xcassets/AppIcon.appiconset"
LAUNCH="${ROOT}/ios/Runner/Assets.xcassets/LaunchImage.imageset"

echo "→ AppIcon.appiconset (from splash_logo.png)"
while IFS= read -r line; do
  dim="${line%% *}"
  fn="${line#* }"
  sips -z "$dim" "$dim" "$SRC" --out "${ICONSET}/${fn}" >/dev/null
done <<'SIZES'
16 16.png
20 20.png
29 29.png
32 32.png
40 40.png
48 48.png
50 50.png
55 55.png
57 57.png
58 58.png
60 60.png
64 64.png
66 66.png
72 72.png
76 76.png
80 80.png
87 87.png
88 88.png
92 92.png
100 100.png
102 102.png
108 108.png
114 114.png
120 120.png
128 128.png
144 144.png
152 152.png
167 167.png
172 172.png
180 180.png
196 196.png
216 216.png
234 234.png
256 256.png
258 258.png
512 512.png
1024 1024.png
SIZES

echo "→ LaunchImage.imageset"
sips -z 220 220 "$SRC" --out "${LAUNCH}/LaunchImage.png" >/dev/null
sips -z 440 440 "$SRC" --out "${LAUNCH}/LaunchImage@2x.png" >/dev/null
sips -z 660 660 "$SRC" --out "${LAUNCH}/LaunchImage@3x.png" >/dev/null

echo "→ Android mipmap platrare.png"
sips -z 48 48 "$SRC" --out "${ROOT}/android/app/src/main/res/mipmap-mdpi/platrare.png" >/dev/null
sips -z 72 72 "$SRC" --out "${ROOT}/android/app/src/main/res/mipmap-hdpi/platrare.png" >/dev/null
sips -z 96 96 "$SRC" --out "${ROOT}/android/app/src/main/res/mipmap-xhdpi/platrare.png" >/dev/null
sips -z 144 144 "$SRC" --out "${ROOT}/android/app/src/main/res/mipmap-xxhdpi/platrare.png" >/dev/null
sips -z 192 192 "$SRC" --out "${ROOT}/android/app/src/main/res/mipmap-xxxhdpi/platrare.png" >/dev/null

echo "→ app_icon.png (mirror for tooling / docs)"
cp "$SRC" "${ROOT}/assets/branding/app_icon.png"

echo "Done."
