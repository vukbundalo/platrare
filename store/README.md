# Store listing assets

Not bundled into the app. Everything a store console asks for, in one place.

| Item | Where | Notes |
|---|---|---|
| Play hi-res icon 512×512 | `play/icon-512.png` | Derived from the iOS 1024 icon (white plate). |
| Play feature graphic 1024×500 | `play/feature-graphic-1024x500.png` | Generated from `assets/branding/splash_logo.png` + Inter. Regenerate if the logo changes. |
| Play title / short / full description | `listing/en-US/*.txt` | Short description ≤ 80 chars, full ≤ 4000. |
| App Store subtitle / keywords | `listing/en-US/subtitle_ios.txt`, `keywords_ios.txt` | Subtitle ≤ 30 chars, keywords ≤ 100 chars comma-separated. Description = `full_description.txt`. |
| Release notes | `listing/en-US/release_notes_<version>.txt` | |
| Screenshots | **missing** | Need a device: iPhone 6.9" (1320×2868) and 6.5" (1284×2778) for App Store; phone screenshots for Play. Suggested set: Plan timeline, Track list with day panel, Review statistics, account detail with a person and debt classification, backup/lock settings. |
| Privacy policy URL | `lib/config/app_urls.dart` | Host `docs/PRIVACY_POLICY.md` publicly (GitHub Pages) and point both consoles there. |
| Support URL / email | `lib/config/app_urls.dart` | Required by App Store Connect. |

Android launcher icon: adaptive + monochrome layers live in
`android/app/src/main/res/mipmap-*/ic_launcher_{foreground,monochrome}.png` and
`mipmap-anydpi-v26/platrare.xml`; the legacy `platrare.png` files stay as the pre-API-26 fallback.
