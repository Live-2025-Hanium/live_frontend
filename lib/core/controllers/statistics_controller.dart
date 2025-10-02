import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/repositories/statistics_repository.dart';
import 'package:live_frontend/models/statistics_model.dart';

final statisticsControllerProvider = Provider(
  (ref) => StatisticsController(ref.read(statisticsRepositoryProvider)),
);

class StatisticsController {
  final StatisticsRepository _repository;

  StatisticsController(this._repository);

  Future<MonthlyCompletionRateModel?> fetchMonthlyCloverRate(
    String yearMonth,
  ) async {
    try {
      return await _repository.fetchMonthlyCloverRate(yearMonth);
    } catch (e) {
      return null;
    }
  }

  Future<MonthlyCompletionRateModel?> fetchMonthlyMyRate(
    String yearMonth,
  ) async {
    try {
      return await _repository.fetchMonthlyMyRate(yearMonth);
    } catch (e) {
      return null;
    }
  }
}
