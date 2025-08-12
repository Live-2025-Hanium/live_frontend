// lib/models/my_mission_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'my_mission_model.g.dart';

/// 요일 enum (서버 값과 1:1 매핑)
@JsonEnum(alwaysCreate: true)
enum RepeatDay {
  @JsonValue('MONDAY')
  monday,
  @JsonValue('TUESDAY')
  tuesday,
  @JsonValue('WEDNESDAY')
  wednesday,
  @JsonValue('THURSDAY')
  thursday,
  @JsonValue('FRIDAY')
  friday,
  @JsonValue('SATURDAY')
  saturday,
  @JsonValue('SUNDAY')
  sunday,
}

/// 'yyyy-MM-dd' → DateTime
DateTime _dateFromYMD(String v) => DateTime.parse(v);

/// DateTime → 'yyyy-MM-dd'
String _dateToYMD(DateTime d) => d.toIso8601String().split('T').first;

@JsonSerializable(explicitToJson: true)
class MyMissionModel {
  final int myMissionId;
  final String missionTitle;

  /// 서버는 'yyyy-MM-dd' 문자열을 주고받는다고 가정
  @JsonKey(fromJson: _dateFromYMD, toJson: _dateToYMD)
  final DateTime startDate;

  @JsonKey(fromJson: _dateFromYMD, toJson: _dateToYMD)
  final DateTime endDate;

  /// 예시: ["08:30", "21:00"] (24시간 기준 권장)
  final List<String> scheduledTime;

  final List<RepeatDay> repeatDays;

  final bool active;

  const MyMissionModel({
    required this.myMissionId,
    required this.missionTitle,
    required this.startDate,
    required this.endDate,
    required this.scheduledTime,
    required this.repeatDays,
    required this.active,
  });

  factory MyMissionModel.fromJson(Map<String, dynamic> json) =>
      _$MyMissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyMissionModelToJson(this);

  MyMissionModel copyWith({
    int? myMissionId,
    String? missionTitle,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? scheduledTime,
    List<RepeatDay>? repeatDays,
    bool? active,
  }) {
    return MyMissionModel(
      myMissionId: myMissionId ?? this.myMissionId,
      missionTitle: missionTitle ?? this.missionTitle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      repeatDays: repeatDays ?? this.repeatDays,
      active: active ?? this.active,
    );
  }
}
