import 'package:json_annotation/json_annotation.dart';
import 'package:live_frontend/models/clover_mission_model.dart';

part 'statistics_model.g.dart';

enum DayOfWeek {
  MONDAY(0),
  TUESDAY(1),
  WEDNESDAY(2),
  THURSDAY(3),
  FRIDAY(4),
  SATURDAY(5),
  SUNDAY(6);

  final int value;
  const DayOfWeek(this.value);

  static DayOfWeek fromApiString(String apiValue) {
    return DayOfWeek.values.firstWhere(
      (day) => day.name.toUpperCase() == apiValue.toUpperCase(),
      orElse: () => throw ArgumentError('Invalid API value: $apiValue'),
    );
  }
}

class DayOfWeekConverter implements JsonConverter<DayOfWeek, String> {
  const DayOfWeekConverter();

  @override
  DayOfWeek fromJson(String json) => DayOfWeek.fromApiString(json); // 문자열 -> Enum

  @override
  String toJson(DayOfWeek object) => object.name.toUpperCase(); // Enum -> 문자열
}

@JsonSerializable()
class MonthlyCompletionRateModel {
  final int totalAssigned;
  final int totalCompleted;
  final double completionRate;

  MonthlyCompletionRateModel({
    required this.totalAssigned,
    required this.totalCompleted,
    required this.completionRate,
  });

  factory MonthlyCompletionRateModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyCompletionRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$MonthlyCompletionRateModelToJson(this);
}

@JsonSerializable()
class WeeklyMissionSummaryModel {
  final String weekStartDate;
  final String weekEndDate;
  final List<DailyMissionSummary> weeklySummary;
  WeeklyMissionSummaryModel({
    required this.weekStartDate,
    required this.weekEndDate,
    required this.weeklySummary,
  });
  factory WeeklyMissionSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyMissionSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeeklyMissionSummaryModelToJson(this);
}

@JsonSerializable()
class DailyMissionSummary {
  final String date;

  @DayOfWeekConverter()
  final DayOfWeek dayOfWeek;

  final int missionCount;

  DailyMissionSummary({
    required this.date,
    required this.dayOfWeek,
    required this.missionCount,
  });

  factory DailyMissionSummary.fromJson(Map<String, dynamic> json) =>
      _$DailyMissionSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$DailyMissionSummaryToJson(this);

  int get dayOfWeekValue => dayOfWeek.value;
}

@JsonSerializable()
class MonthlyGrowthModel {
  final int previousMonth;
  final int currentMonth;
  final List<GrowthSummary> growthSummary;
  MonthlyGrowthModel({
    required this.previousMonth,
    required this.currentMonth,
    required this.growthSummary,
  });
  factory MonthlyGrowthModel.fromJson(Map<String, dynamic> json) =>
      _$MonthlyGrowthModelFromJson(json);
  Map<String, dynamic> toJson() => _$MonthlyGrowthModelToJson(this);
}

@JsonSerializable()
class GrowthSummary {
  final int rank;
  final CloverMissionCategory categoryName;
  final int previousMonthCount;
  final int currentMonthCount;
  final double growthPercentage;

  GrowthSummary({
    required this.rank,
    required this.categoryName,
    required this.previousMonthCount,
    required this.currentMonthCount,
    required this.growthPercentage,
  });
  factory GrowthSummary.fromJson(Map<String, dynamic> json) =>
      _$GrowthSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$GrowthSummaryToJson(this);
}
