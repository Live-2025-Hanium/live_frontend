import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:live_frontend/providers/secure_storage_provider.dart';
import 'package:live_frontend/providers/token_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['API_BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  dio.interceptors.addAll([
    TokenInterceptor(storage, baseUrl: dotenv.env['API_BASE_URL'] ?? ''),
    LogInterceptor(responseBody: true),
  ]);

  return dio;
});
