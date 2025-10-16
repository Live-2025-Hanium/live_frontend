# Flutter 앱의 메인 액티비티가 난독화되거나 제거되는 것을 방지합니다.

# 앱의 메인 액티비티 보호
-keep class app.live.hanium.livefrontend.MainActivity { *; }

# 2. Flutter 기본 클래스 보호
-keep class * extends io.flutter.embedding.android.FlutterActivity { *; }
-keep class * extends io.flutter.app.FlutterActivity { *; }

# Kakao SDK
-keep class com.kakao.sdk.** { *; }
-dontwarn com.kakao.sdk.**

# Gson (used by Kakao SDK for JSON parsing)
-keep class * extends com.google.gson.TypeAdapter { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keepattributes Signature
-keepattributes *Annotation*

# OkHttp (used by Kakao SDK for networking)
-dontwarn okhttp3.**
-dontwarn okio.**

# Kotlin Coroutines (used by Kakao SDK)
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.android.AndroidExceptionPreHandler {}
-keepnames class kotlinx.coroutines.android.AndroidDispatcherFactory {}

