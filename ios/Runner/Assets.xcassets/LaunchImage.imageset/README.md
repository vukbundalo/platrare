# Launch Screen Assets

`LaunchImage.png` / `LaunchImage@2x.png` / `LaunchImage@3x.png` are resized from
`AppIcon.appiconset/1024.png` so the native iOS launch matches the app icon.

To refresh after changing the master icon, regenerate with:

```bash
SRC=ios/Runner/Assets.xcassets/AppIcon.appiconset/1024.png
DEST=ios/Runner/Assets.xcassets/LaunchImage.imageset
sips -z 220 220 "$SRC" --out "$DEST/LaunchImage.png"
sips -z 440 440 "$SRC" --out "$DEST/LaunchImage@2x.png"
sips -z 660 660 "$SRC" --out "$DEST/LaunchImage@3x.png"
```

Also copy `1024.png` to `assets/branding/app_icon.png` for the Flutter splash.
