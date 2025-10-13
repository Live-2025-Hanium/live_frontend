# Flutter 앱의 메인 액티비티가 난독화되거나 제거되는 것을 방지합니다.

# 앱의 메인 액티비티 보호
-keep class app.live.hanium.livefrontend.MainActivity { *; }

# 2. Flutter 기본 클래스 보호
-keep class * extends io.flutter.embedding.android.FlutterActivity { *; }
-keep class * extends io.flutter.app.FlutterActivity { *; }
