import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/profile_model.dart';
import 'package:live_frontend/providers/dio_provider.dart';

final profileControllerProvider = Provider(
  (ref) => ProfileController(ref.read(dioProvider)),
);

// 나중에 레포지토리 패턴 지켜서 리팩토링하기
class ProfileController {
  final Dio _dio;
  ProfileController(this._dio);

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
}
