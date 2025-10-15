import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/repositories/statistics_repository.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/models/statistics_model.dart';

final statisticsControllerProvider = Provider(
  (ref) => StatisticsController(ref.read(statisticsRepositoryProvider)),
);

class StatisticsController {
  final StatisticsRepository _repository;

  StatisticsController(this._repository);

  Future<MonthlyCompletionRateModel?> fetchMonthlyCompletionRate(
    String yearMonth,
    MissionType missionType,
  ) async {
    try {
      return await _repository.fetchMonthlyCompletionRate(
        yearMonth,
        missionType,
      );
    } catch (e) {
      return null;
    }
  }

  Future<WeeklyMissionSummaryModel?> fetchWeeklyMissionSummary(
    String date,
    MissionType missionType,
  ) async {
    try {
      return await _repository.fetchWeeklyMissionSummary(date, missionType);
    } catch (e) {
      return null;
    }
  }

  Future<MonthlyGrowthModel?> fetchMonthlyGrowth(String yearMonth) async {
    try {
      return await _repository.fetchMonthlyGrowth(yearMonth);
    } catch (e) {
      return null;
    }
  }
}
