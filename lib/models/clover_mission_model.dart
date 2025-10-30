import 'package:json_annotation/json_annotation.dart';
import 'mission_models.dart';

part 'clover_mission_model.g.dart';

Duration _parseDurationFromString(String? time) {
  if (time == null) return Duration.zero;
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

  static CloverMissionDifficulty fromValue(int value) {
    return CloverMissionDifficulty.values.firstWhere(
      (difficulty) => difficulty.value == value,
      orElse: () => CloverMissionDifficulty.normal,
    );
  }
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
  final CloverMissionType cloverType;

  CloverMissionModel({
    required this.userMissionId,
    required this.missionTitle,
    required this.missionStatus,
    required this.missionDifficulty,
    required this.missionCategory,
    required this.cloverType,
  });

  factory CloverMissionModel.fromJson(Map<String, dynamic> json) =>
      _$CloverMissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CloverMissionModelToJson(this);

  // copyWith 구현하기
  CloverMissionModel copyWith({
    int? userMissionId,
    String? missionTitle,
    MissionStatus? missionStatus,
    CloverMissionDifficulty? missionDifficulty,
    CloverMissionCategory? missionCategory,
    CloverMissionType? cloverType,
  }) {
    return CloverMissionModel(
      userMissionId: userMissionId ?? this.userMissionId,
      missionTitle: missionTitle ?? this.missionTitle,
      missionStatus: missionStatus ?? this.missionStatus,
      missionDifficulty: missionDifficulty ?? this.missionDifficulty,
      missionCategory: missionCategory ?? this.missionCategory,
      cloverType: cloverType ?? this.cloverType,
    );
  }
}

@JsonSerializable()
class CloverMissionDetailModel extends CloverMissionModel {
  @JsonKey(fromJson: _parseDurationFromString, toJson: _formatDurationToString)
  final Duration? remainingTime;
  final int? remainingDistance;
  final String? placeName;
  final String? address;
  final String? latitude;
  final String? longitude;

  CloverMissionDetailModel({
    required super.userMissionId,
    required super.cloverType,
    required super.missionTitle,
    required super.missionStatus,
    required super.missionCategory,
    required super.missionDifficulty,
    this.placeName,
    this.address,
    this.latitude,
    this.longitude,
    this.remainingTime,
    this.remainingDistance,
  });

  factory CloverMissionDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CloverMissionDetailModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CloverMissionDetailModelToJson(this);
}

@JsonSerializable()
class CloverMissionFeedbackModel {
  final int userMissionId;
  final String feedbackComment;
  final CloverMissionDifficulty feedbackDifficulty;
  final String? imageUrl;

  CloverMissionFeedbackModel({
    required this.userMissionId,
    required this.feedbackComment,
    required this.feedbackDifficulty,
    this.imageUrl,
  });
  factory CloverMissionFeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$CloverMissionFeedbackModelFromJson(json);
  Map<String, dynamic> toJson() => _$CloverMissionFeedbackModelToJson(this);
}
