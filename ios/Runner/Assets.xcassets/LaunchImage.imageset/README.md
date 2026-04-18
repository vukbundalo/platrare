# Launch Screen Assets

`LaunchImage*.png` are generated from **`assets/branding/splash_logo.png`** (same
master as the app icon and Flutter splash). Regenerate whenever you change the
logo:

```bash
bash tool/sync_branding_icons.sh
```

The script resizes into this imageset and updates `AppIcon.appiconset`,
Android `mipmap-*/platrare.png`, and `assets/branding/app_icon.png`.
