// lib/data/repositories/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/saeip_user_model.dart';
import 'package:live_frontend/providers/dio_provider.dart';
import '../models/user.dart';

class AuthRepository {
  final Dio _dio;
  AuthRepository(this._dio);

  /// 카카오 액세스 토큰을 백엔드로 전달하고, 회원 정보를 받아옵니다.
  Future<SaeipUserModel> loginWithKakaoOnBackend(
    AppUser user,
    String accessToken,
  ) async {
    final resp = await _dio.post(
      '/api/auth/kakao/login',
      data: {
        'oauthId': 'kakao_${user.id}',
        'email': user.email,
        'nickname': user.name,
        'profileImageUrl': user.profileImageUrl,
      },
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return SaeipUserModel.fromJson(resp.data['user']);
  }

  /// Google idToken을 백엔드로 전달하고, 회원 정보를 받아옵니다.
  Future<SaeipUserModel> loginWithGoogleOnBackend(String idToken) async {
    final resp = await _dio.post('/auth/google', data: {'token': idToken});
    return SaeipUserModel.fromJson(resp.data['user']);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});
