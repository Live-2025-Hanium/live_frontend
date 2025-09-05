import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:live_frontend/providers/secure_storage_provider.dart';
import 'package:live_frontend/providers/token_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);

  final baseOptions = BaseOptions(
    baseUrl: dotenv.env['API_BASE_URL'] ?? '',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  );

  final dio = Dio(baseOptions);

  dio.interceptors.addAll([
    // pass the same BaseOptions to TokenInterceptor for refresh requests
    TokenInterceptor(storage, refreshOptions: baseOptions),
    LogInterceptor(responseBody: true),
  ]);

  return dio;
});
