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
            .map(
              (item) => MyMissionModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
      return apiResponse.data ?? [];
    } catch (e) {
      debugPrint('Failed to fetch my missions: $e');
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
      await _dio.patch('/api/v1/missions/my/$userMissionId/complete');
    } catch (e) {
      debugPrint('Failed to complete my mission via API: $e');
      rethrow;
    }
  }

  Future<List<AllMyMissionsModel>?> fetchAllMyMissions() async {
    try {
      final response = await _dio.get('/api/v1/missions/my');
      final apiResponse = ApiResponseModel<List<AllMyMissionsModel>>.fromJson(
        response.data,
        (json) => (json as List)
            .map(
              (item) =>
                  AllMyMissionsModel.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
      debugPrint('API Response Data: ${apiResponse.data}');
      return apiResponse.data;
    } catch (e) {
      debugPrint('Failed to fetch all my missions: $e');
      return null;
    }
  }

  Future<void> toggleMissionStatus(int missionId, bool isActive) async {
    try {
      await _dio.patch(
        '/api/v1/missions/my/$missionId/active',
        queryParameters: {'active': isActive.toString()},
      );
    } catch (e) {
      debugPrint('Failed to toggle mission status via API: $e');
      rethrow;
    }
  }
}
