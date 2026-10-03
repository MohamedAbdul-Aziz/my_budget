#!/usr/bin/env bash
# Takes the Play Store phone screenshots (1080x1920) and saves them into
# fastlane/metadata/android/<locale>/images/phoneScreenshots/.
#
#   ./scripts/store_screenshots.sh            # all 20 store languages
#   ./scripts/store_screenshots.sh en-US ar   # just these
#
# The app runs as a macOS desktop app, drawn as an Android phone, so no
# emulator is needed. DEVICE=<id> runs it on a phone or emulator instead.
set -euo pipefail

cd "$(dirname "$0")/.."

DEVICE="${DEVICE:-macos}"
LOCALES=("$@")
if [[ ${#LOCALES[@]} -eq 0 ]]; then
  LOCALES=(en-US ar zh-CN es-ES fr-FR pt-BR ru-RU de-DE ja-JP ko-KR tr-TR id it-IT fa ur vi pl-PL nl-NL uk ms)
fi

for locale in "${LOCALES[@]}"; do
  dir="fastlane/metadata/android/$locale/images/phoneScreenshots"
  echo "== $locale"
  rm -rf "$dir"
  SCREENSHOT_DIR="$dir" flutter drive \
    -d "$DEVICE" \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/store_screenshots_test.dart \
    --dart-define=STORE_LOCALE="$locale"
done

echo "Done. Check the images, then commit them."
