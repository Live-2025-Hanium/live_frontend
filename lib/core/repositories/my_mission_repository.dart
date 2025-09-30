import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/providers/dio_provider.dart';

final myMissionRepositoryProvider = Provider<MyMissionRepository>((ref) {
  final dio = ref.read(dioProvider);
  return MyMissionRepository(dio);
});

class MyMissionRepository {
  final Dio _dio;

  MyMissionRepository(this._dio);

  Future<List<MyMissionModel>> fetchMyMissions() async {
    try {
      final response = await _dio.get('/api/v1/missions/my/today');
      final apiResponse = ApiResponseModel<List<MyMissionModel>>.fromJson(
        response.data,
        (json) => (json as List)
            .map((item) => MyMissionModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
      return apiResponse.data ?? [];
    } catch (e) {
      debugPrint('Failed to fetch my missions: $e');
      // In case of an error, return an empty list or handle it as needed.
      return [];
    }
  }

  Future<void> addMyMission(MyMissionAddPayloadModel mission) async {
    try {
      await _dio.post('/api/v1/missions/my', data: mission.toJson());
    } catch (e) {
      debugPrint('Failed to add my mission via API: $e');
      rethrow;
    }
  }

  Future<void> completeMyMission(int userMissionId) async {
    try {
      await _dio.patch('/my-missions/$userMissionId/complete');
    } catch (e) {
      debugPrint('Failed to complete my mission via API: $e');
      rethrow;
    }
  }
}
