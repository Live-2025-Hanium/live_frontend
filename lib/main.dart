import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:live_frontend/env.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  KakaoSdk.init(nativeAppKey: Env.kakaoNativeAppKey);
  await Jiffy.setLocale('ko');
  AuthRepository.initialize(
    appKey: dotenv.env['KAKAO_JS_APP_KEY'] ?? 'default_app_key',
    baseUrl: 'http://localhost',
  );
  runApp(const ProviderScope(child: MyApp()));
}
