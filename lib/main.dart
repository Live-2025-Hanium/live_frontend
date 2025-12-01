import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:live_frontend/env.dart';
import 'package:jiffy/jiffy.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // runApp을 Zone으로 감싸서 비동기 코드의 모든 오류를 처리
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true; // 오류를 처리했음을 알림
  };

  KakaoSdk.init(nativeAppKey: Env.kakaoNativeAppKey);
  AuthRepository.initialize(
    appKey: Env.kakaoJsAppKey,
    baseUrl: 'https://localhost',
  );
  await Jiffy.setLocale('ko_Kr', startOfWeek: StartOfWeek.monday);
  runApp(const ProviderScope(child: MyApp()));
}
