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
