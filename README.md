# 🗑️ Android Debloat Lists

Safe-to-remove package lists for every major Android OEM. All commands use `adb shell pm uninstall -k --user 0` — no root required.

> **How it works:** This doesn't truly uninstall system apps, it removes them for the current user. Packages can be restored with `adb shell cmd package install-existing <package>`.

---

## How to use

```bash
# Connect device via USB with USB debugging enabled
adb devices   # verify connection

# Remove a package (safe — user-level only)
adb shell pm uninstall -k --user 0 <package.name>

# Restore a package (if something breaks)
adb shell cmd package install-existing <package.name>
```

---

## Debloat lists

| OEM | File | Packages |
|-----|------|----------|
| Samsung | [samsung.txt](lists/samsung.txt) | 60+ |
| Xiaomi / MIUI / HyperOS | [xiaomi.txt](lists/xiaomi.txt) | 50+ |
| Google Pixel | [pixel.txt](lists/pixel.txt) | 20+ |
| OnePlus | [oneplus.txt](lists/oneplus.txt) | 35+ |
| Universal (all Android) | [universal.txt](lists/universal.txt) | 30+ |

---

## Danger zones ⚠️

**NEVER remove these** (will brick or bootloop):
- `com.android.systemui` — the entire UI
- `com.android.settings` — you'll be locked out
- `com.android.providers.settings` — system database
- `com.google.android.gms` — if you use any Google services
- `com.android.phone` — cellular radio
- `com.android.nfc` — breaks NFC stack on some devices

---

## Quick debloat script

```bash
#!/bin/bash
# Usage: ./debloat.sh lists/samsung.txt
while IFS= read -r pkg; do
  [[ "$pkg" =~ ^#.*$ ]] && continue
  [[ -z "$pkg" ]] && continue
  echo "Removing: $pkg"
  adb shell pm uninstall -k --user 0 "$pkg" 2>/dev/null
done < "$1"
echo "Done!"
```

---

*See also: [android-tweaks-toolkit](https://github.com/OutrageousStorm/android-tweaks-toolkit) · [ROM Haven wiki](https://romhaven.wikioasis.org)*
