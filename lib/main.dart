import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'firebase_options.dart';
import 'app.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

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

  AuthRepository.initialize(
    appKey: Env.kakaoJsAppKey
  );

  runApp(const ProviderScope(child: MyApp()));
}
