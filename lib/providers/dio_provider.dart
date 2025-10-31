import 'package:live_frontend/providers/token_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:live_frontend/env.dart';
import 'package:live_frontend/providers/secure_storage_provider.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'dart:io';
import 'package:dio/io.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);

  final baseOptions = BaseOptions(
    baseUrl: Env.apiBase,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  );

  final dio = Dio(baseOptions);

  // 🛠️ Android HandshakeException 진단 코드 추가 🛠️
  if (Platform.isAndroid) {
    try {
      // Dio 5.x 이상 버전이라면:
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    } catch (e) {
      // Dio 버전 호환성 문제 등으로 오류가 날 경우를 대비
      print("Error configuring badCertificateCallback for Android: $e");
    }
  }
  // ----------------------------------------------

  dio.interceptors.addAll([
    // pass the same BaseOptions to TokenInterceptor for refresh requests
    TokenInterceptor(
      storage,
      refreshOptions: baseOptions,
      onLogout: () => ref.read(authProvider.notifier).logout(),
    ),
    LogInterceptor(responseBody: true),
  ]);

  return dio;
});
