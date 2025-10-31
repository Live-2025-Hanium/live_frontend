import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/models/statistics_model.dart';
import 'package:live_frontend/providers/dio_provider.dart';

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  final dio = ref.read(dioProvider);
  return StatisticsRepository(dio);
});

class StatisticsRepository {
  final Dio _dio;

  StatisticsRepository(this._dio);

  Future<MonthlyCompletionRateModel?> fetchMonthlyCompletionRate(
    String yearMonth,
    MissionType missionType,
  ) async {
    try {
      final endpoint = missionType == MissionType.clover
          ? '/api/v1/analysis/clover/participation'
          : '/api/v1/analysis/my/participation';

      final response = await _dio.get(
        endpoint,
        queryParameters: {'yearMonth': yearMonth},
      );
      final apiResponse = ApiResponseModel<MonthlyCompletionRateModel>.fromJson(
        response.data,
        (json) =>
            MonthlyCompletionRateModel.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data;
    } catch (e) {
      //  debugPrint('Failed to fetch monthly completion rate: $e');
      return null;
    }
  }

  Future<WeeklyMissionSummaryModel?> fetchWeeklyMissionSummary(
    String date,
    MissionType missionType,
  ) async {
    try {
      final endpoint = missionType == MissionType.clover
          ? '/api/v1/analysis/clover/weekly'
          : '/api/v1/analysis/my/weekly';
      final response = await _dio.get(
        endpoint,
        queryParameters: {'date': date},
      );
      final apiResponse = ApiResponseModel<WeeklyMissionSummaryModel>.fromJson(
        response.data,
        (json) =>
            WeeklyMissionSummaryModel.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data;
    } catch (e) {
      //  debugPrint('Failed to fetch weekly mission summary: $e');
      return null;
    }
  }

  Future<MonthlyGrowthModel?> fetchMonthlyGrowth(String yearMonth) async {
    try {
      final response = await _dio.get(
        '/api/v1/analysis/clover/growth',
        // queryParameters: {'yearMonth': yearMonth},  아직 추가 안됨
      );
      final apiResponse = ApiResponseModel<MonthlyGrowthModel>.fromJson(
        response.data,
        (json) => MonthlyGrowthModel.fromJson(json as Map<String, dynamic>),
      );

      return apiResponse.data;
    } catch (e) {
      //  debugPrint('Failed to fetch monthly growth: $e');
      return null;
    }
  }

  Future<DailyCompletedMissionsModel?> fetchDailyCompletedMissions(
    String date,
    MissionType missionType,
  ) async {
    try {
      final endpoint = missionType == MissionType.clover
          ? '/api/v1/analysis/clover/daily'
          : '/api/v1/analysis/my/daily';
      final response = await _dio.get(
        endpoint,
        queryParameters: {'date': date},
      );
      final apiResponse =
          ApiResponseModel<DailyCompletedMissionsModel>.fromJson(
            response.data,
            (json) => DailyCompletedMissionsModel.fromJson(
              json as Map<String, dynamic>,
            ),
          );

      return apiResponse.data;
    } catch (e) {
      //  debugPrint('Failed to fetch daily completed missions: $e');
      return null;
    }
  }
}
