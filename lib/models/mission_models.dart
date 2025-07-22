import 'package:json_annotation/json_annotation.dart';

part 'mission_models.g.dart';

// TODO : 이후 클로버미션, 마이미션 분리 필요

// 기존 enum들
enum MissionStatus {
  @JsonValue('ASSIGNED')
  assigned,
  @JsonValue('STARTED')
  started,
  @JsonValue('PAUSED')
  paused,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('SKIPPED')
  skipped,
}

@JsonEnum(alwaysCreate: true)
enum MissionDifficulty {
  @JsonValue('VERY_EASY')
  veryEasy(1),
  @JsonValue('EASY')
  easy(2),
  @JsonValue('NORMAL')
  normal(3),
  @JsonValue('HARD')
  hard(4),
  @JsonValue('VERY_HARD')
  veryHard(5);

  final int value;
  const MissionDifficulty(this.value);
}

// 추가된 MissionCategory enum
enum MissionCategory {
  @JsonValue('RELATIONSHIP')
  relationship,
  @JsonValue('HEALTH')
  health,
  @JsonValue('WORK')
  work,
  @JsonValue('HOBBY')
  hobby,
  @JsonValue('STUDY')
  study,
}

// Mission 모델
@JsonSerializable()
class Mission {
  final int userMissionId;
  final String title;
  final MissionStatus missionStatus;
  final MissionDifficulty missionDifficulty;
  final MissionCategory missionCategory;

  Mission({
    required this.userMissionId,
    required this.title,
    required this.missionStatus,
    required this.missionDifficulty,
    required this.missionCategory,
  });

  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);
  Map<String, dynamic> toJson() => _$MissionToJson(this);
}

// Mission Data 모델 (missions 배열을 포함하는 data 부분)
@JsonSerializable()
class MissionData {
  final int userId;
  final List<Mission> missions;

  MissionData({required this.userId, required this.missions});

  factory MissionData.fromJson(Map<String, dynamic> json) =>
      _$MissionDataFromJson(json);
  Map<String, dynamic> toJson() => _$MissionDataToJson(this);
}

// Error 모델
@JsonSerializable()
class ApiError {
  final String code;
  final String message;

  ApiError({required this.code, required this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);
}

// 전체 API Response 모델
@JsonSerializable()
class MissionResponse {
  final String timestamp;
  final bool success;
  final String message;
  final MissionData? data;
  final ApiError? error;

  MissionResponse({
    required this.timestamp,
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory MissionResponse.fromJson(Map<String, dynamic> json) =>
      _$MissionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MissionResponseToJson(this);
}
