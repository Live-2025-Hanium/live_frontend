// lib/models/my_mission_model.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:live_frontend/models/mission_models.dart';

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

enum MissionType {
  @JsonValue('MY')
  my,
  @JsonValue('CLOVER')
  clover,
}

@JsonSerializable(explicitToJson: true)
class MyMissionModel {
  final int userMissionId;
  final MissionType missionType; // "MY" / "CLOVER"

  final String missionTitle;
  final MissionStatus missionStatus;

  /// 예시: ["08:30", "21:00"] (24시간 기준 권장)
  final List<String> scheduledTime;

  final List<RepeatDay> repeatDays;

  const MyMissionModel({
    required this.userMissionId,
    required this.missionType,
    required this.missionTitle,
    required this.missionStatus,
    required this.scheduledTime,
    required this.repeatDays,
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
      userMissionId: myMissionId ?? userMissionId,
      missionType: missionType,
      missionTitle: missionTitle ?? this.missionTitle,
      missionStatus: missionStatus,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      repeatDays: repeatDays ?? this.repeatDays,
    );
  }
}
