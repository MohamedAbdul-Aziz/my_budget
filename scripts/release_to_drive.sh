#!/usr/bin/env bash
# Builds the release app bundle, then uploads it to Google Drive.
set -euo pipefail

cd "$(dirname "$0")/.."

flutter build appbundle --release
./scripts/upload_to_drive.sh
