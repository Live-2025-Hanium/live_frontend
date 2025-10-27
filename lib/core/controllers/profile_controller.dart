import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/repositories/profile_repository.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/profile_model.dart';

final profileControllerProvider = Provider(
  (ref) => ProfileController(ref.read(profileRepositoryProvider)),
);

class ProfileController {
  final ProfileRepository _repository;

  ProfileController(this._repository);

  Future<ProfileModel?> fetchProfile() async {
    try {
      return await _repository.fetchProfile();
    } catch (e) {
      return null;
    }
  }

  Future<NicknameDuplicationCheckResponse> checkNicknameDuplicated(
    String nickname,
  ) async {
    final notAvailable = NicknameDuplicationCheckResponse(
      message: '네트워크 오류가 발생했습니다.',
      available: false,
    );

    try {
      final response = await _repository.checkNicknameDuplicated(nickname);

      return NicknameDuplicationCheckResponse(
        message: response?.message ?? '네트워크 오류가 발생했습니다.',
        available: response?.available ?? false,
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final apiResp = ApiResponseModel<Null>.fromJson(
          e.response!.data,
          (raw) => null,
        );
        if (apiResp.error == null) {
          return notAvailable;
        }

        return NicknameDuplicationCheckResponse(
          message: apiResp.error!.message,
          available: false,
        );
      }
      return notAvailable;
    } catch (e) {
      return notAvailable;
    }
  }

  Future<bool> updateProfile(ProfileUpdatePayloadModel payload) async {
    try {
      debugPrint('✅ 프로필 업데이트 페이로드: ${payload.toJson()}');
      await _repository.updateProfile(payload);
      return true;
    } catch (e) {
      return false;
    }
  }
}
