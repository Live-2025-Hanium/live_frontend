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

CloverMissionDetailModel _$CloverMissionDetailModelFromJson(
  Map<String, dynamic> json,
) => CloverMissionDetailModel(
  userMissionId: (json['userMissionId'] as num).toInt(),
  cloverType: $enumDecode(_$CloverMissionTypeEnumMap, json['cloverType']),
  missionTitle: json['missionTitle'] as String,
  description: json['description'] as String,
  missionStatus: $enumDecode(_$MissionStatusEnumMap, json['missionStatus']),
  missionDifficulty: $enumDecode(
    _$CloverMissionDifficultyEnumMap,
    json['missionDifficulty'],
  ),
  missionCategory: $enumDecode(
    _$CloverMissionCategoryEnumMap,
    json['missionCategory'],
  ),
  remainingTime: _parseDurationFromString(json['remainingTime'] as String),
  targetAddress: json['targetAddress'] as String?,
  remainingDistance: (json['remainingDistance'] as num?)?.toInt(),
  illustrationUrl: json['illustrationUrl'] as String,
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
  'description': instance.description,
  'cloverType': _$CloverMissionTypeEnumMap[instance.cloverType]!,
  'remainingTime': _formatDurationToString(instance.remainingTime),
  'targetAddress': instance.targetAddress,
  'remainingDistance': instance.remainingDistance,
  'illustrationUrl': instance.illustrationUrl,
};

const _$CloverMissionTypeEnumMap = {
  CloverMissionType.timer: 'TIMER',
  CloverMissionType.distance: 'DISTANCE',
  CloverMissionType.visit: 'VISIT',
  CloverMissionType.photo: 'PHOTO',
};
