#!/usr/bin/env bash
set -euo pipefail
export PATH="$PWD/flutter/bin:$PATH"
flutter build web --release \
  --dart-define-from-file=.vercel/defines.json
chmod +x vercel/install.sh vercel/build.sh
