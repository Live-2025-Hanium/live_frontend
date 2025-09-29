import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:live_frontend/env.dart';
import 'package:live_frontend/providers/secure_storage_provider.dart';
import 'package:live_frontend/providers/token_interceptor.dart';
import 'package:live_frontend/providers/auth_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);

  final baseOptions = BaseOptions(
    baseUrl: Env.apiBase,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  );

  final dio = Dio(baseOptions);

  dio.interceptors.addAll([
    // pass the same BaseOptions to TokenInterceptor for refresh requests
    TokenInterceptor(
      storage,
      refreshOptions: baseOptions,
      onLogout: () => ref.read(authProvider.notifier).logout(),
    ),
    LogInterceptor(responseBody: true),
  ]);

  // Example: to call an endpoint without attaching Authorization header,
  // pass Options with extra['noAuth'] == true:
  // await dio.get('/public', options: Options(extra: {'noAuth': true}));

  return dio;
});
