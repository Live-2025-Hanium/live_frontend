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

  // 🛠️ 개선된 인증서 검증 우회 방식
  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  };
  // ----------------------------------------------------

  dio.interceptors.addAll([
    TokenInterceptor(
      storage,
      refreshOptions: baseOptions,
      onLogout: () => ref.read(authProvider.notifier).logout(),
    ),
    LogInterceptor(responseBody: true),
  ]);

  return dio;
});
