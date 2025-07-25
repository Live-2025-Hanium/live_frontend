import 'package:json_annotation/json_annotation.dart';
import 'mission_models.dart';

part 'clover_mission_model.g.dart';

Duration _parseDurationFromString(String time) {
  final parts = time.split(':');
  final minutes = int.parse(parts[0]);
  final seconds = int.parse(parts[1]);
  return Duration(minutes: minutes, seconds: seconds);
}

String _formatDurationToString(Duration? duration) {
  if (duration == null) return '00:00';
  two(int n) => n.toString().padLeft(2, '0');
  return '${two(duration.inMinutes)}:${two(duration.inSeconds.remainder(60))}';
}

@JsonEnum(alwaysCreate: true)
enum CloverMissionDifficulty {
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
  const CloverMissionDifficulty(this.value);
}

enum CloverMissionCategory {
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

extension CloverMissionCategoryExtension on CloverMissionCategory {
  String get koreanLabel {
    switch (this) {
      case CloverMissionCategory.relationship:
        return '관계';
      case CloverMissionCategory.health:
        return '건강 챙기기';
      case CloverMissionCategory.work:
        return '업무';
      case CloverMissionCategory.hobby:
        return '취미';
      case CloverMissionCategory.study:
        return '공부';
    }
  }
}

enum CloverMissionType {
  @JsonValue('TIMER')
  timer,
  @JsonValue('DISTANCE')
  distance,
  @JsonValue('VISIT')
  visit,
  @JsonValue('PHOTO')
  photo,
}

@JsonSerializable()
class CloverMissionModel {
  final int userMissionId;

  final String missionTitle;

  final MissionStatus missionStatus;
  final CloverMissionDifficulty missionDifficulty;
  final CloverMissionCategory missionCategory;

  CloverMissionModel({
    required this.userMissionId,
    required this.missionTitle,
    required this.missionStatus,
    required this.missionDifficulty,
    required this.missionCategory,
  });

  factory CloverMissionModel.fromJson(Map<String, dynamic> json) =>
      _$CloverMissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CloverMissionModelToJson(this);
}

@JsonSerializable()
class CloverMissionDetailModel extends CloverMissionModel {
  final String description;
  final CloverMissionType cloverType;
  @JsonKey(fromJson: _parseDurationFromString, toJson: _formatDurationToString)
  final Duration? remainingTime;
  final String? targetAddress;
  final int? remainingDistance;
  final String illustrationUrl;

  CloverMissionDetailModel({
    required super.userMissionId,
    required this.cloverType,
    required super.missionTitle,
    required this.description,
    required super.missionStatus,
    required super.missionDifficulty,
    required super.missionCategory,
    this.remainingTime,
    this.targetAddress,
    this.remainingDistance,
    required this.illustrationUrl,
  });

  factory CloverMissionDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CloverMissionDetailModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CloverMissionDetailModelToJson(this);
}
