// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clover_mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CloverMissionModel _$CloverMissionModelFromJson(Map<String, dynamic> json) =>
    CloverMissionModel(
      userMissionId: (json['userMissionId'] as num).toInt(),
      missionTitle: json['missionTitle'] as String,
      missionStatus: $enumDecode(_$MissionStatusEnumMap, json['missionStatus']),
      missionDifficulty: $enumDecode(
        _$CloverMissionDifficultyEnumMap,
        json['missionDifficulty'],
      ),
      missionCategory: $enumDecode(
        _$CloverMissionCategoryEnumMap,
        json['missionCategory'],
      ),
      cloverType: $enumDecode(_$CloverMissionTypeEnumMap, json['cloverType']),
    );

Map<String, dynamic> _$CloverMissionModelToJson(
  CloverMissionModel instance,
) => <String, dynamic>{
  'userMissionId': instance.userMissionId,
  'missionTitle': instance.missionTitle,
  'missionStatus': _$MissionStatusEnumMap[instance.missionStatus]!,
  'missionDifficulty':
      _$CloverMissionDifficultyEnumMap[instance.missionDifficulty]!,
  'missionCategory': _$CloverMissionCategoryEnumMap[instance.missionCategory]!,
  'cloverType': _$CloverMissionTypeEnumMap[instance.cloverType]!,
};

const _$MissionStatusEnumMap = {
  MissionStatus.assigned: 'ASSIGNED',
  MissionStatus.started: 'STARTED',
  MissionStatus.paused: 'PAUSED',
  MissionStatus.completed: 'COMPLETED',
  MissionStatus.skipped: 'SKIPPED',
};

const _$CloverMissionDifficultyEnumMap = {
  CloverMissionDifficulty.veryEasy: 'VERY_EASY',
  CloverMissionDifficulty.easy: 'EASY',
  CloverMissionDifficulty.normal: 'NORMAL',
  CloverMissionDifficulty.hard: 'HARD',
  CloverMissionDifficulty.veryHard: 'VERY_HARD',
};

const _$CloverMissionCategoryEnumMap = {
  CloverMissionCategory.relationship: 'RELATIONSHIP',
  CloverMissionCategory.health: 'HEALTH',
  CloverMissionCategory.work: 'WORK',
  CloverMissionCategory.hobby: 'HOBBY',
  CloverMissionCategory.study: 'STUDY',
};

const _$CloverMissionTypeEnumMap = {
  CloverMissionType.timer: 'TIMER',
  CloverMissionType.distance: 'DISTANCE',
  CloverMissionType.visit: 'VISIT',
  CloverMissionType.photo: 'PHOTO',
};

CloverMissionDetailModel _$CloverMissionDetailModelFromJson(
  Map<String, dynamic> json,
) => CloverMissionDetailModel(
  userMissionId: (json['userMissionId'] as num).toInt(),
  cloverType: $enumDecode(_$CloverMissionTypeEnumMap, json['cloverType']),
  missionTitle: json['missionTitle'] as String,
  missionStatus: $enumDecode(_$MissionStatusEnumMap, json['missionStatus']),
  missionCategory: $enumDecode(
    _$CloverMissionCategoryEnumMap,
    json['missionCategory'],
  ),
  missionDifficulty: $enumDecode(
    _$CloverMissionDifficultyEnumMap,
    json['missionDifficulty'],
  ),
  placeName: json['placeName'] as String?,
  address: json['address'] as String?,
  latitude: json['latitude'] as String?,
  longitude: json['longitude'] as String?,
  remainingTime: _parseDurationFromString(json['remainingTime'] as String?),
  remainingDistance: (json['remainingDistance'] as num?)?.toInt(),
);

Map<String, dynamic> _$CloverMissionDetailModelToJson(
  CloverMissionDetailModel instance,
) => <String, dynamic>{
  'userMissionId': instance.userMissionId,
  'missionTitle': instance.missionTitle,
  'missionStatus': _$MissionStatusEnumMap[instance.missionStatus]!,
  'missionDifficulty':
      _$CloverMissionDifficultyEnumMap[instance.missionDifficulty]!,
  'missionCategory': _$CloverMissionCategoryEnumMap[instance.missionCategory]!,
  'cloverType': _$CloverMissionTypeEnumMap[instance.cloverType]!,
  'remainingTime': _formatDurationToString(instance.remainingTime),
  'remainingDistance': instance.remainingDistance,
  'placeName': instance.placeName,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

CloverMissionFeedbackModel _$CloverMissionFeedbackModelFromJson(
  Map<String, dynamic> json,
) => CloverMissionFeedbackModel(
  userMissionId: (json['userMissionId'] as num).toInt(),
  feedbackComment: json['feedbackComment'] as String,
  feedbackDifficulty: $enumDecode(
    _$CloverMissionDifficultyEnumMap,
    json['feedbackDifficulty'],
  ),
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$CloverMissionFeedbackModelToJson(
  CloverMissionFeedbackModel instance,
) => <String, dynamic>{
  'userMissionId': instance.userMissionId,
  'feedbackComment': instance.feedbackComment,
  'feedbackDifficulty':
      _$CloverMissionDifficultyEnumMap[instance.feedbackDifficulty]!,
  'imageUrl': instance.imageUrl,
};
