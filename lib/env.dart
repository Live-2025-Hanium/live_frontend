class Env {
  static const apiBase = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  static const kakaoNativeAppKey = String.fromEnvironment(
    'KAKAO_NATIVE_APP_KEY',
    defaultValue: 'dummy_key',
  );
  static const kakaoRestApiKey = String.fromEnvironment(
    'KAKAO_REST_API_KEY',
    defaultValue: '',
  );
  static const kakaoRedirectUri = String.fromEnvironment(
    'KAKAO_REDIRECT_URI',
    defaultValue: '',
  );
  static const kakaoJsAppKey = String.fromEnvironment(
    'KAKAO_JS_APP_KEY',
    defaultValue: '',
  );
  static const googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '',
  );
  static const firebaseAndroidApiKey = String.fromEnvironment(
    'FIREBASE_ANDROID_API_KEY',
    defaultValue: '',
  );
  static const firebaseIosApiKey = String.fromEnvironment(
    'FIREBASE_IOS_API_KEY',
    defaultValue: '',
  );
  static const firebaseWebApiKey = String.fromEnvironment(
    'FIREBASE_WEB_API_KEY',
    defaultValue: '',
  );
  static const firebaseAndroidAppId = String.fromEnvironment(
    'FIREBASE_ANDROID_APP_ID',
    defaultValue: '',
  );
  static const firebaseIosAppId = String.fromEnvironment(
    'FIREBASE_IOS_APP_ID',
    defaultValue: '',
  );
  static const firebaseWebAppId = String.fromEnvironment(
    'FIREBASE_WEB_APP_ID',
    defaultValue: '',
  );
  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );
  static const firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '',
  );
  static const firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: '',
  );
  static const iosBundleId = String.fromEnvironment(
    'FIREBASE_IOS_BUNDLE_ID',
    defaultValue: '',
  );
}
