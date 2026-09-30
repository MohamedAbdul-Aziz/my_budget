#!/usr/bin/env bash
# Copies the existing release app bundle into the Google Drive for desktop
# folder, waits for the upload, then quits Google Drive again.
# UPLOAD_WAIT (seconds) controls how long to keep Drive open for the upload.
set -euo pipefail

DRIVE_DIR_NAME="${DRIVE_DIR:-my_budget/releases}"
UPLOAD_WAIT="${UPLOAD_WAIT:-120}"
AAB="build/app/outputs/bundle/release/app-release.aab"

cd "$(dirname "$0")/.."

if [[ ! -f "$AAB" ]]; then
  echo "No build found at $AAB. Run: flutter build appbundle --release" >&2
  exit 1
fi

VERSION="$(grep -m1 '^version:' pubspec.yaml | awk '{print $2}')"
STAMP="$(date +%Y%m%d-%H%M)"
NAME="my_budget-v${VERSION}-${STAMP}.aab"

echo "Starting Google Drive..."
open -a "Google Drive"

# Wait for the Drive folder to be mounted.
DRIVE_ROOT=""
for _ in {1..60}; do
  for dir in "$HOME"/Library/CloudStorage/GoogleDrive-*/"My Drive"; do
    [[ -d "$dir" ]] && DRIVE_ROOT="$dir" && break 2
  done
  sleep 2
done
if [[ -z "$DRIVE_ROOT" ]]; then
  echo "Google Drive folder did not appear." >&2
  exit 1
fi

DEST="$DRIVE_ROOT/$DRIVE_DIR_NAME"

# Drive may still be starting up and reject writes for a while, so retry.
copied=false
for _ in {1..30}; do
  if mkdir -p "$DEST" 2>/dev/null && cp "$AAB" "$DEST/$NAME" 2>/dev/null; then
    copied=true
    break
  fi
  sleep 5
done
if [[ "$copied" != true ]]; then
  echo "Could not write to Google Drive (is your Drive storage full?)." >&2
  echo "The build is still at $AAB" >&2
  exit 1
fi
echo "Copied to $DEST/$NAME"

echo "Waiting ${UPLOAD_WAIT}s for the upload..."
sleep "$UPLOAD_WAIT"

osascript -e 'quit app "Google Drive"'
echo "Done. Google Drive closed."
