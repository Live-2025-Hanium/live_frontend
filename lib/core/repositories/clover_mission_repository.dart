import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/providers/dio_provider.dart';

final cloverMissionRepositoryProvider = Provider<CloverMissionRepository>((
  ref,
) {
  final dio = ref.read(dioProvider); // Dio 인스턴스 생성 또는 주입
  return CloverMissionRepository(dio);
});

class CloverMissionRepository {
  final Dio _dio;

  CloverMissionRepository(this._dio);

  Future<List<CloverMissionModel>?> getCloverMissions() async {
    final position = await Geolocator.getCurrentPosition();

    final response = await _dio.get(
      "/api/v1/missions/clover",
      queryParameters: {'lat': position.latitude, 'lon': position.longitude},
    );

    final apiResponse = ApiResponseModel.fromJson(response.data, (json) {
      if (json is! Map<String, dynamic> || json['missions'] == null) {
        return <CloverMissionModel>[];
      }
      return (json['missions'] as List)
          .map(
            (item) => CloverMissionModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    });

    return apiResponse.data;
  }

  Future<void> updateCloverMissionStatus(
    MissionStatus status,
    int missionId,
  ) async {
    await _dio.patch('/api/v1/missions/clover/$missionId/${status.label}');
  }

  Future<List<CloverMissionModel>?> fetchNewMissions() async {
    final position = await Geolocator.getCurrentPosition();

    final response = await _dio.get(
      "/api/v1/missions/clover/refill",
      queryParameters: {'lat': position.latitude, 'lon': position.longitude},
    );

    if (response.statusCode == 200) {
      final apiResponse = ApiResponseModel.fromJson(response.data, (json) {
        if (json is! Map<String, dynamic> || json['missions'] == null) {
          return <CloverMissionModel>[];
        }
        return (json['missions'] as List)
            .map(
              (item) =>
                  CloverMissionModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      });
      return apiResponse.data;
    } else {
      throw Exception('Failed to fetch new clover missions');
    }
  }

  Future<CloverMissionDetailModel?> getCloverMissionDetail(
    int missionId,
  ) async {
    final response = await _dio.get('/api/v1/missions/clover/$missionId');

    if (response.statusCode == 200) {
      final apiResponse = ApiResponseModel.fromJson(
        response.data,
        (json) =>
            CloverMissionDetailModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data;
    } else {
      throw Exception('Failed to load clover mission detail');
    }
  }
}
