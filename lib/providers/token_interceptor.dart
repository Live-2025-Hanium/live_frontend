import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/token_model.dart';
import 'package:live_frontend/providers/secure_storage_provider.dart';

class TokenInterceptor extends Interceptor {
  final SecureStorageService storage;
  final void Function()? onLogout;
  final Dio _refreshDio;
  final String refreshEndpoint = '/api/auth/refresh';

  // Simple mutex to avoid parallel refresh requests
  Completer<void>? _refreshCompleter;

  /// Accept a [refreshOptions] to construct the internal refresh Dio.
  TokenInterceptor(this.storage, {BaseOptions? refreshOptions, this.onLogout})
    : _refreshDio = Dio(refreshOptions ?? BaseOptions(baseUrl: '')) {
    // 🛠️ _refreshDio에도 인증서 검증 우회 적용
    if (Platform.isAndroid || Platform.isIOS) {
      (_refreshDio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
          () {
            final client = HttpClient();
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
            return client;
          };
    }
  }

  Future<String?> _readAccess() => storage.readAccess();
  Future<String?> _readRefresh() => storage.readRefresh();
  Future<void> _writeTokens(String access, String refresh) async =>
      storage.writeTokens(access, refresh);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // If caller set extra['noAuth'] = true, do not attach tokens.
    final noAuth = options.extra['noAuth'] == true;
    if (noAuth) {
      return handler.next(options);
    }
    try {
      final access = await _readAccess();
      if (access != null && access.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $access';
      }
    } catch (e) {
      // if (kDebugMode) debugPrint('TokenInterceptor read access error: $e');
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If original request asked to skip auth, don't attempt refresh/retry.
    final originalNoAuth = err.requestOptions.extra['noAuth'] == true;
    final isLogout = err.requestOptions.path == '/api/auth/logout';

    // Only handle 401 from server (unauthorized)
    if (!originalNoAuth && err.response?.statusCode == 401 && !isLogout) {
      try {
        // If a refresh is already in progress, wait for it
        if (_refreshCompleter != null) {
          await _refreshCompleter!.future;
        } else {
          _refreshCompleter = Completer();
          try {
            final refreshToken = await _readRefresh();
            if (refreshToken == null || refreshToken.isEmpty) {
              throw Exception('No refresh token available');
            }

            final response = await _refreshDio.post(
              refreshEndpoint,
              data: {'refreshToken': refreshToken},
            );

            final data = ApiResponseModel.fromJson(
              response.data,
              (json) => TokenModel.fromJson(json as Map<String, dynamic>),
            );

            if (data.data == null) {
              throw Exception('Invalid refresh response: ${response.data}');
            }

            final newAccessToken = data.data!.accessToken;
            final newRefreshToken = data.data!.refreshToken;

            await _writeTokens(newAccessToken, newRefreshToken);
          } finally {
            _refreshCompleter?.complete();
            _refreshCompleter = null;
          }
        }

        // retry original request with new access token
        final access = await _readAccess();
        if (access != null && access.isNotEmpty) {
          // Clone and send the request using the refresh Dio so that
          // we don't re-run the interceptors on the main Dio instance.
          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $access';
          final cloneReq = await _refreshDio.request(
            requestOptions.path,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
            options: Options(
              method: requestOptions.method,
              headers: requestOptions.headers,
            ),
          );
          return handler.resolve(cloneReq);
        }
      } catch (e, s) {
        if (kDebugMode) {}
        try {
          await storage.delete(TokenKeys.access);
          await storage.delete(TokenKeys.refresh);
        } catch (e) {}

        if (onLogout != null) {
          try {
            onLogout!();
          } catch (e) {}
        }
      }
    }

    return handler.next(err);
  }
}
