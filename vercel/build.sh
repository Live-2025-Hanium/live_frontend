#!/usr/bin/env bash
set -euo pipefail
export PATH="$PWD/flutter/bin:$PATH"
flutter build web --release --wasm=false --web-renderer=html \
  --dart-define-from-file=.vercel/defines.json
chmod +x vercel/install.sh vercel/build.sh
