import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  late final Dio dio;
  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    )..interceptors.add(LogInterceptor(responseBody: true));
  }
}

final dioProvider = Provider<Dio>((ref) {
  return ApiClient().dio;
});
