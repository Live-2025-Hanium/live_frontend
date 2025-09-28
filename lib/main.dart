import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'package:live_frontend/env.dart';
import 'package:jiffy/jiffy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Jiffy.setLocale('ko');

  KakaoSdk.init(
    nativeAppKey: Env.kakaoNativeAppKey,
    javaScriptAppKey: Env.kakaoJsAppKey,
  );

  final jsKey = Env.kakaoJsAppKey;
  assert(
    jsKey.isNotEmpty,
    'KAKAO_JS_APP_KEY is empty. Pass --dart-define=KAKAO_JS_APP_KEY=...',
  );

  // JS SDK의 origin으로 쓸 baseUrl
  // - Web: 현재 오리진
  // - App(iOS/Android): dart-define이 있으면 그 값, 없으면 'http://localhost'
  final baseUrl = kIsWeb ? Uri.base.origin : 'http://localhost';

  AuthRepository.initialize(appKey: jsKey, baseUrl: baseUrl);

  runApp(const ProviderScope(child: MyApp()));
}
