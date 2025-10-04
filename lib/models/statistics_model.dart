import 'package:json_annotation/json_annotation.dart';

part 'statistics_model.g.dart';

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
