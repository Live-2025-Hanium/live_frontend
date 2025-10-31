// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyCompletionRateModel _$MonthlyCompletionRateModelFromJson(
  Map<String, dynamic> json,
) => MonthlyCompletionRateModel(
  totalAssigned: (json['totalAssigned'] as num).toInt(),
  totalCompleted: (json['totalCompleted'] as num).toInt(),
  completionRate: (json['completionRate'] as num).toDouble(),
);

Map<String, dynamic> _$MonthlyCompletionRateModelToJson(
  MonthlyCompletionRateModel instance,
) => <String, dynamic>{
  'totalAssigned': instance.totalAssigned,
  'totalCompleted': instance.totalCompleted,
  'completionRate': instance.completionRate,
};

WeeklyMissionSummaryModel _$WeeklyMissionSummaryModelFromJson(
  Map<String, dynamic> json,
) => WeeklyMissionSummaryModel(
  weekStartDate: json['weekStartDate'] as String,
  weekEndDate: json['weekEndDate'] as String,
  weeklySummary: (json['weeklySummary'] as List<dynamic>)
      .map((e) => DailyMissionSummary.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WeeklyMissionSummaryModelToJson(
  WeeklyMissionSummaryModel instance,
) => <String, dynamic>{
  'weekStartDate': instance.weekStartDate,
  'weekEndDate': instance.weekEndDate,
  'weeklySummary': instance.weeklySummary,
};

DailyMissionSummary _$DailyMissionSummaryFromJson(Map<String, dynamic> json) =>
    DailyMissionSummary(
      date: json['date'] as String,
      dayOfWeek: const DayOfWeekConverter().fromJson(
        json['dayOfWeek'] as String,
      ),
      missionCount: (json['missionCount'] as num).toInt(),
    );

Map<String, dynamic> _$DailyMissionSummaryToJson(
  DailyMissionSummary instance,
) => <String, dynamic>{
  'date': instance.date,
  'dayOfWeek': const DayOfWeekConverter().toJson(instance.dayOfWeek),
  'missionCount': instance.missionCount,
};

MonthlyGrowthModel _$MonthlyGrowthModelFromJson(Map<String, dynamic> json) =>
    MonthlyGrowthModel(
      previousMonth: (json['previousMonth'] as num).toInt(),
      currentMonth: (json['currentMonth'] as num).toInt(),
      growthSummary: (json['growthSummary'] as List<dynamic>)
          .map((e) => GrowthSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MonthlyGrowthModelToJson(MonthlyGrowthModel instance) =>
    <String, dynamic>{
      'previousMonth': instance.previousMonth,
      'currentMonth': instance.currentMonth,
      'growthSummary': instance.growthSummary,
    };

GrowthSummary _$GrowthSummaryFromJson(Map<String, dynamic> json) =>
    GrowthSummary(
      rank: (json['rank'] as num).toInt(),
      categoryName: $enumDecode(
        _$CloverMissionCategoryEnumMap,
        json['categoryName'],
      ),
      previousMonthCount: (json['previousMonthCount'] as num).toInt(),
      currentMonthCount: (json['currentMonthCount'] as num).toInt(),
      growthPercentage: (json['growthPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$GrowthSummaryToJson(GrowthSummary instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'categoryName': _$CloverMissionCategoryEnumMap[instance.categoryName]!,
      'previousMonthCount': instance.previousMonthCount,
      'currentMonthCount': instance.currentMonthCount,
      'growthPercentage': instance.growthPercentage,
    };

const _$CloverMissionCategoryEnumMap = {
  CloverMissionCategory.communication: 'COMMUNICATION',
  CloverMissionCategory.relationship: 'RELATIONSHIP',
  CloverMissionCategory.environment: 'ENVIRONMENT',
  CloverMissionCategory.health: 'HEALTH',
};

DailyCompletedMissionsModel _$DailyCompletedMissionsModelFromJson(
  Map<String, dynamic> json,
) => DailyCompletedMissionsModel(
  date: json['date'] as String,
  dayOfWeek: const DayOfWeekConverter().fromJson(json['dayOfWeek'] as String),
  completedMissions: (json['completedMissions'] as List<dynamic>)
      .map((e) => CompletedMission.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DailyCompletedMissionsModelToJson(
  DailyCompletedMissionsModel instance,
) => <String, dynamic>{
  'date': instance.date,
  'dayOfWeek': const DayOfWeekConverter().toJson(instance.dayOfWeek),
  'completedMissions': instance.completedMissions,
};

CompletedMission _$CompletedMissionFromJson(Map<String, dynamic> json) =>
    CompletedMission(
      missionId: (json['missionId'] as num).toInt(),
      missionRecordId: (json['missionRecordId'] as num).toInt(),
      missionTitle: json['missionTitle'] as String,
      completedAt: json['completedAt'] as String,
    );

Map<String, dynamic> _$CompletedMissionToJson(CompletedMission instance) =>
    <String, dynamic>{
      'missionId': instance.missionId,
      'missionRecordId': instance.missionRecordId,
      'missionTitle': instance.missionTitle,
      'completedAt': instance.completedAt,
    };
