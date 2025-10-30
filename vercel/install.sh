#!/usr/bin/env bash
set -euo pipefail
if [ ! -d flutter ]; then
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git
fi
export PATH="$PWD/flutter/bin:$PATH"
flutter config --enable-web
flutter pub get
mkdir -p .vercel
printf '{"API_BASE_URL":"%s","KAKAO_NATIVE_APP_KEY":"%s","KAKAO_REST_API_KEY":"%s","KAKAO_REDIRECT_URI":"%s","KAKAO_JS_APP_KEY":"%s","GOOGLE_IOS_CLIENT_ID":"%s", "FIREBASE_WEB_API_KEY":"%s", "FIREBASE_WEB_APP_ID":"%s", "FIREBASE_PROJECT_ID":"%s", "FIREBASE_MESSAGING_SENDER_ID":"%s", "FIREBASE_STORAGE_BUCKET":"%s"}' \
  "$API_BASE_URL" "$KAKAO_NATIVE_APP_KEY" "$KAKAO_REST_API_KEY" "$KAKAO_REDIRECT_URI" "$KAKAO_JS_APP_KEY" "$GOOGLE_IOS_CLIENT_ID" "$FIREBASE_WEB_API_KEY" "$FIREBASE_WEB_APP_ID" "$FIREBASE_PROJECT_ID" "$FIREBASE_MESSAGING_SENDER_ID" "$FIREBASE_STORAGE_BUCKET" \
  > .vercel/defines.json
