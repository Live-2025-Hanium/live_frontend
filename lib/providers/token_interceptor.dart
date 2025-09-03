import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:live_frontend/providers/secure_storage_provider.dart';

/// A Dio interceptor that attaches access token and handles automatic refresh.
class TokenInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Dio _refreshDio;
  final String refreshEndpoint = '/api/auth/refresh';

  // Simple mutex to avoid parallel refresh requests
  Completer<void>? _refreshCompleter;

  TokenInterceptor(this.storage, {String? baseUrl})
    : _refreshDio = Dio(BaseOptions(baseUrl: baseUrl ?? ''));

  Future<String?> _readAccess() => storage.read(key: TokenKeys.access);
  Future<String?> _readRefresh() => storage.read(key: TokenKeys.refresh);
  Future<void> _writeTokens(String access, String refresh) async {
    await storage.write(key: TokenKeys.access, value: access);
    await storage.write(key: TokenKeys.refresh, value: refresh);
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final access = await _readAccess();
      if (access != null && access.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $access';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('TokenInterceptor read access error: $e');
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 from server (unauthorized)
    if (err.response?.statusCode == 401) {
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

            final resp = await _refreshDio.post(
              refreshEndpoint,
              data: {'refreshToken': refreshToken},
            );

            // Backend returns envelope: { success: true, data: { accessToken, refreshToken, ... } }
            final respMap = resp.data as Map<String, dynamic>?;
            final payload = respMap != null && respMap.containsKey('data')
                ? respMap['data'] as Map<String, dynamic>
                : (respMap ?? <String, dynamic>{});
            final newAccess = payload['accessToken'] as String?;
            final newRefresh = payload['refreshToken'] as String?;
            if (newAccess == null || newRefresh == null) {
              throw Exception('Invalid refresh response: ${resp.data}');
            }

            await _writeTokens(newAccess, newRefresh);
          } finally {
            _refreshCompleter?.complete();
            _refreshCompleter = null;
          }
        }

        // retry original request with new access token
        final access = await _readAccess();
        if (access != null && access.isNotEmpty) {
          err.requestOptions.headers['Authorization'] = 'Bearer $access';
          final cloneReq = await _refreshDio.request(
            err.requestOptions.path,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
          );
          return handler.resolve(cloneReq);
        }
      } catch (e, s) {
        if (kDebugMode) {
          debugPrint('Token refresh failed: $e');
          debugPrintStack(stackTrace: s);
        }
        // fallthrough to propagate original error
      }
    }

    return handler.next(err);
  }
}
