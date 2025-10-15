import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/controllers/statistics_controller.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/models/statistics_model.dart';

class StatisticsApiPayload {
  final String yearMonth;
  final MissionType missionType;

  StatisticsApiPayload({required this.yearMonth, required this.missionType});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticsApiPayload &&
          runtimeType == other.runtimeType &&
          yearMonth == other.yearMonth &&
          missionType == other.missionType;

  @override
  int get hashCode => yearMonth.hashCode ^ missionType.hashCode;
}

final monthlyCompletionRateProvider =
    FutureProvider.family<MonthlyCompletionRateModel?, StatisticsApiPayload>((
      ref,
      payload,
    ) {
      final controller = ref.read(statisticsControllerProvider);
      return controller.fetchMonthlyCompletionRate(
        payload.yearMonth,
        payload.missionType,
      );
    });

final weeklyCompletionRatesProvider =
    FutureProvider.family<WeeklyMissionSummaryModel?, StatisticsApiPayload>((
      ref,
      payload,
    ) {
      final controller = ref.read(statisticsControllerProvider);
      return controller.fetchWeeklyMissionSummary(
        payload.yearMonth,
        payload.missionType,
      );
    });

final monthlyGrowthProvider =
    FutureProvider.family<MonthlyGrowthModel?, String>((ref, yearMonth) {
      final controller = ref.read(statisticsControllerProvider);
      return controller.fetchMonthlyGrowth(yearMonth);
    });
