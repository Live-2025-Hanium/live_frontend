import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/saeip_user_model.dart';
import 'package:live_frontend/models/social_user_model.dart';
import 'package:live_frontend/providers/dio_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:live_frontend/providers/secure_storage_provider.dart';

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  AuthRepository(this._dio, this._secureStorage);

  /// 카카오 액세스 토큰을 백엔드로 전달하고, 회원 정보를 받아옵니다.
  /// NOTE: 백엔드 응답은 { success, message, data: { user, accessToken, refreshToken, newUser }, ... } 형태
  Future<SaeipUserModel> loginWithKakaoOnBackend(
    SocialUser user,
    String accessToken,
  ) async {
    try {
      final resp = await _dio.post(
        '/api/auth/kakao/login',
        data: {
          'oauthId': 'kakao_${user.id}',
          'email': user.email,
          'nickname': user.name,
          'profileImageUrl': user.profileImageUrl,
        },
        // 백엔드에서 카카오 토큰 검증용으로 Bearer 받는다면 OK
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      final apiResp = ApiResponseModel<LoginData>.fromJson(
        resp.data,
        (raw) => LoginData.fromJson(Map<String, dynamic>.from(raw as Map)),
      );
      if (apiResp.data == null) {
        throw Exception('Login response missing data: ${resp.data}');
      }

      // Persist tokens securely
      final login = apiResp.data!;
      try {
        await _secureStorage.write(
          key: TokenKeys.access,
          value: login.accessToken,
        );
        await _secureStorage.write(
          key: TokenKeys.refresh,
          value: login.refreshToken,
        );
      } catch (e) {
        if (kDebugMode) debugPrint('Failed to persist tokens: $e');
      }

      return login.user;
    } on DioException catch (e, s) {
      if (kDebugMode) {
        debugPrint('loginWithKakaoOnBackend DioException: ${e.response?.data}');
        debugPrintStack(stackTrace: s);
      }
      rethrow;
    }
  }

  /// Google idToken을 백엔드로 전달하고, 회원 정보를 받아옵니다.
  /// 백엔드가 같은 응답 스펙(data 안에 user/토큰/newUser)이라면 동일하게 파싱
  Future<SaeipUserModel> loginWithGoogleOnBackend(String idToken) async {
    try {
      final resp = await _dio.post('/auth/google', data: {'token': idToken});

      final apiResp = ApiResponseModel<LoginData>.fromJson(
        resp.data,
        (raw) => LoginData.fromJson(Map<String, dynamic>.from(raw as Map)),
      );
      if (apiResp.data == null) {
        throw Exception('Login response missing data: ${resp.data}');
      }

      final login = apiResp.data!;
      try {
        await _secureStorage.write(
          key: TokenKeys.access,
          value: login.accessToken,
        );
        await _secureStorage.write(
          key: TokenKeys.refresh,
          value: login.refreshToken,
        );
      } catch (e) {
        if (kDebugMode) debugPrint('Failed to persist tokens: $e');
      }

      return login.user;
    } on DioException catch (e, s) {
      if (kDebugMode) {
        debugPrint(
          'loginWithGoogleOnBackend DioException: ${e.response?.data}',
        );
        debugPrintStack(stackTrace: s);
      }
      rethrow;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(dio, storage);
});
