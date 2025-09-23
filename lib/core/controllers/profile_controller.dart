import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/profile_model.dart';
import 'package:live_frontend/providers/dio_provider.dart';

final profileControllerProvider = Provider((ref) => ProfileController(ref));

class ProfileController {
  final Ref ref;
  ProfileController(this.ref);

  Future<ProfileModel?> fetchProfile() async {
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.get('/api/members/me');

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
