import 'package:json_annotation/json_annotation.dart';
import 'package:live_frontend/models/mission_models.dart';

part 'my_mission_model.g.dart';

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
  @JsonValue('EVERYDAY')
  everyday,
  @JsonValue('WEEKDAYS')
  weekdays,
  @JsonValue('WEEKEND')
  weekend,
}

extension RepeatDayLabel on RepeatDay {
  String get label {
    switch (this) {
      case RepeatDay.monday:
        return '월요일마다';
      case RepeatDay.tuesday:
        return '화요일마다';
      case RepeatDay.wednesday:
        return '수요일마다';
      case RepeatDay.thursday:
        return '목요일마다';
      case RepeatDay.friday:
        return '금요일마다';
      case RepeatDay.saturday:
        return '토요일마다';
      case RepeatDay.sunday:
        return '일요일마다';
      case RepeatDay.everyday:
        return '매일마다';
      case RepeatDay.weekdays:
        return '평일마다';
      case RepeatDay.weekend:
        return '주말마다';
    }
  }
}

enum MissionType {
  @JsonValue('MY')
  my,
  @JsonValue('CLOVER')
  clover,
}

@JsonSerializable(explicitToJson: true)
class MyMissionModel {
  final int userMissionId;
  final String missionTitle;
  final MissionStatus myMissionStatus;
  final String? scheduledTime;
  final RepeatDay? repeatType;

  const MyMissionModel({
    required this.userMissionId,
    required this.missionTitle,
    required this.myMissionStatus,
    this.scheduledTime,
    this.repeatType,
  });

  factory MyMissionModel.fromJson(Map<String, dynamic> json) =>
      _$MyMissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyMissionModelToJson(this);

  MyMissionModel copyWith({
    int? myMissionId,
    String? missionTitle,
    DateTime? startDate,
    DateTime? endDate,
    String? scheduledTime,
    RepeatDay? repeatDay,
    bool? active,
  }) {
    return MyMissionModel(
      userMissionId: myMissionId ?? userMissionId,
      missionTitle: missionTitle ?? this.missionTitle,
      myMissionStatus: myMissionStatus ?? myMissionStatus,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      repeatType: repeatType ?? repeatType,
    );
  }
}

@JsonSerializable()
class MyMissionAddModel {
  String? missionTitle;
  DateTime? startDate;
  DateTime? endDate;
  String? scheduledTime;
  RepeatDay? repeatDay;

  MyMissionAddModel({
    this.missionTitle,
    this.startDate,
    this.endDate,
    this.scheduledTime,
    this.repeatDay,
  });

  static DateTime parseTime(String? time) {
    if (time == null || time.isEmpty) {
      return DateTime.now();
    }
    final parts = time.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid time format');
    }
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);
    if (hours == null || minutes == null) {
      throw FormatException('Invalid time format');
    }
    return DateTime(0, 0, 0, hours, minutes);
  }

  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '00:00';
    }
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  factory MyMissionAddModel.fromJson(Map<String, dynamic> json) =>
      _$MyMissionAddModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyMissionAddModelToJson(this);
}

@JsonSerializable()
class MyMissionAddPayloadModel {
  final String missionTitle;
  final String? startDate;
  final String? endDate;
  final String? scheduledTime;
  final RepeatDay? repeatDay;

  MyMissionAddPayloadModel({
    required this.missionTitle,
    this.startDate,
    this.endDate,
    this.scheduledTime,
    this.repeatDay,
  });

  factory MyMissionAddPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$MyMissionAddPayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyMissionAddPayloadModelToJson(this);
}

@JsonSerializable()
class AllMyMissionsModel {
  final int myMissionId;
  final String missionTitle;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? scheduledTime;
  final RepeatDay? repeatType;
  final bool active;

  AllMyMissionsModel({
    required this.myMissionId,
    required this.missionTitle,
    required this.startDate,
    required this.endDate,
    required this.scheduledTime,
    required this.repeatType,
    required this.active,
  });

  factory AllMyMissionsModel.fromJson(Map<String, dynamic> json) =>
      _$AllMyMissionsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllMyMissionsModelToJson(this);
}

class ToggleMissionStatusPayload {
  final int missionId;
  final bool isActive;

  ToggleMissionStatusPayload({required this.missionId, required this.isActive});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ToggleMissionStatusPayload &&
        other.missionId == missionId &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => missionId.hashCode ^ isActive.hashCode;
}
