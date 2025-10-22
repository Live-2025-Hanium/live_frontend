import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/profile_model.dart';
import 'package:live_frontend/providers/dio_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dio = ref.read(dioProvider);
  return ProfileRepository(dio);
});

class ProfileRepository {
  final Dio _dio;

  ProfileRepository(this._dio);

  Future<ProfileModel?> fetchProfile() async {
    try {
      final resp = await _dio.get('/api/members/me');

      final apiResp = ApiResponseModel<ProfileModel>.fromJson(
        resp.data as Map<String, dynamic>,
        (raw) => ProfileModel.fromJson(Map<String, dynamic>.from(raw as Map)),
      );

      return apiResp.data;
    } catch (e) {
      return null;
    }
  }

  Future<NicknameDuplicationCheckModel?> checkNicknameDuplicated(
    String nickname,
  ) async {
    try {
      final resp = await _dio.get(
        '/api/members/nickname/check',
        queryParameters: {'nickname': nickname},
      );

      final apiResp = ApiResponseModel<NicknameDuplicationCheckModel>.fromJson(
        resp.data as Map<String, dynamic>,
        (raw) => NicknameDuplicationCheckModel.fromJson(
          Map<String, dynamic>.from(raw as Map),
        ),
      );

      return apiResp.data;
    } catch (e) {
      return null;
    }
  }
}
