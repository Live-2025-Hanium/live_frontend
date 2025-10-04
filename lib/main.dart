import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

import 'package:live_frontend/env.dart';
import 'package:jiffy/jiffy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    WebViewPlatform.instance = WebWebViewPlatform();
  }
  
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Jiffy.setLocale('ko');

  KakaoSdk.init(
    nativeAppKey: Env.kakaoNativeAppKey,
    javaScriptAppKey: Env.kakaoJsAppKey,
  );

  // kakao_map_plugin 초기화 (JS 키 필수)
  final jsKey = Env.kakaoJsAppKey;

  // JS SDK의 origin(baseUrl) 결정
  final baseUrl = kIsWeb ? Uri.base.origin : 'http://localhost';

  AuthRepository.initialize(appKey: jsKey, baseUrl: baseUrl);

  runApp(const ProviderScope(child: MyApp()));
}
