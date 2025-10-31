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
    // 위치 권한 확인 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('위치 정보 접근이 거부되었습니다.');
      }
    }

    final position = await Geolocator.getCurrentPosition(
      timeLimit: const Duration(seconds: 15),
    );

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
    try {
      final response = await _dio.patch(
        '/api/v1/missions/clover/$missionId/${status.label}',
      );
    } on DioException catch (e) {
      // Dio 관련 오류(네트워크 문제, 2xx 이외의 응답 등)를 처리합니다.
      throw Exception('미션 상태 업데이트 실패: ${e.message}');
    } catch (e) {
      // 그 외 예상치 못한 오류를 처리합니다.
      throw Exception('예상치 못한 오류가 발생했습니다: ${e.toString()}');
    }
  }

  Future<List<CloverMissionModel>?> fetchNewMissions() async {
    // 위치 권한 확인 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('위치 정보 접근이 거부되었습니다.');
      }
    }

    final position = await Geolocator.getCurrentPosition(
      timeLimit: const Duration(seconds: 15),
    );

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

  Future<void> postCloverMissionFeedback(
    CloverMissionFeedbackModel feedback,
  ) async {
    try {
      final response = await _dio.post(
        '/api/v1/missions/records',
        data: feedback.toJson(),
      );
    } on DioException catch (e) {
      // Dio 관련 오류(네트워크 문제, 2xx 이외의 응답 등)를 처리합니다.
      throw Exception('미션 피드백 제출 실패: ${e.message}');
    } catch (e) {
      // 그 외 예상치 못한 오류를 처리합니다.
      throw Exception('예상치 못한 오류가 발생했습니다: ${e.toString()}');
    }
  }
}
