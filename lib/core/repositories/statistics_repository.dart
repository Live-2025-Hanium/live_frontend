import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/statistics_model.dart';
import 'package:live_frontend/providers/dio_provider.dart';

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  final dio = ref.read(dioProvider);
  return StatisticsRepository(dio);
});

class StatisticsRepository {
  final Dio _dio;

  StatisticsRepository(this._dio);

  Future<MonthlyCompletionRateModel?> fetchMonthlyCloverRate(
    String yearMonth,
  ) async {
    try {
      final response = await _dio.get(
        '/api/v1/analysis/clover/participation',
        queryParameters: {'yearMonth': yearMonth},
      );
      final apiResponse = ApiResponseModel<MonthlyCompletionRateModel>.fromJson(
        response.data,
        (json) =>
            MonthlyCompletionRateModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data;
    } catch (e) {
      debugPrint('Failed to fetch monthly completion rate: $e');
      return null;
    }
  }

  Future<MonthlyCompletionRateModel?> fetchMonthlyMyRate(
    String yearMonth,
  ) async {
    try {
      final response = await _dio.get(
        '/api/v1/analysis/my/participation',
        queryParameters: {'yearMonth': yearMonth},
      );
      final apiResponse = ApiResponseModel<MonthlyCompletionRateModel>.fromJson(
        response.data,
        (json) =>
            MonthlyCompletionRateModel.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data;
    } catch (e) {
      debugPrint('Failed to fetch monthly completion rate: $e');
      return null;
    }
  }
}
