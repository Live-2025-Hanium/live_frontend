import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
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
      // if (kDebugMode) debugPrint('ProfileController: fetching /api/members/me');
      final resp = await dio.get('/api/members/me');
      // if (kDebugMode) debugPrint('ProfileController: resp=${resp.data}');

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
