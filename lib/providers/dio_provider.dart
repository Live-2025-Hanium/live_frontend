import 'package:live_frontend/providers/token_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:live_frontend/env.dart';
import 'package:live_frontend/providers/secure_storage_provider.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'dio_adapter_mobile.dart' if (dart.library.html) 'dio_adapter_web.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);

  final baseOptions = BaseOptions(
    baseUrl: Env.apiBase,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  );

  final dio = Dio(baseOptions);

  // 플랫폼에 맞는 어댑터 설정
  configureAdapter(dio);

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
