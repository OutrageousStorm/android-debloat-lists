#!/bin/bash
# Android Debloat Script
# Usage: ./debloat.sh <listfile>
# Example: ./debloat.sh lists/samsung.txt

if [ -z "$1" ]; then
  echo "Usage: $0 <listfile>"
  echo "Available lists:"
  ls -1 lists/*.txt 2>/dev/null | sed 's/^/  /'
  exit 1
fi

if ! adb devices | grep -q "device$"; then
  echo "❌ No device connected. Enable USB debugging and connect your device."
  exit 1
fi

echo "🗑️  Android Debloater"
echo "━━━━━━━━━━━━━━━━━━━━━"
echo "Reading: $1"
echo ""

removed=0
failed=0

while IFS= read -r pkg; do
  # Skip comments and empty lines
  [[ "$pkg" =~ ^#.*$ ]] && continue
  [[ -z "$pkg" ]] && continue
  pkg=$(echo "$pkg" | tr -d '\r' | xargs)  # trim whitespace
  
  result=$(adb shell pm uninstall -k --user 0 "$pkg" 2>&1)
  if echo "$result" | grep -q "Success"; then
    echo "  ✓ $pkg"
    ((removed++))
  else
    echo "  ✗ $pkg (not found or already removed)"
    ((failed++))
  fi
done < "$1"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Removed: $removed"
echo "⏭️  Skipped: $failed"
echo "Done!"
