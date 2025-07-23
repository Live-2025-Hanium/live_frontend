// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mission _$MissionFromJson(Map<String, dynamic> json) => Mission(
  userMissionId: (json['userMissionId'] as num).toInt(),
  title: json['title'] as String,
  missionStatus: $enumDecode(_$MissionStatusEnumMap, json['missionStatus']),
  missionDifficulty: $enumDecode(
    _$MissionDifficultyEnumMap,
    json['missionDifficulty'],
  ),
  missionCategory: $enumDecode(
    _$MissionCategoryEnumMap,
    json['missionCategory'],
  ),
);

Map<String, dynamic> _$MissionToJson(Mission instance) => <String, dynamic>{
  'userMissionId': instance.userMissionId,
  'title': instance.title,
  'missionStatus': _$MissionStatusEnumMap[instance.missionStatus]!,
  'missionDifficulty': _$MissionDifficultyEnumMap[instance.missionDifficulty]!,
  'missionCategory': _$MissionCategoryEnumMap[instance.missionCategory]!,
};

const _$MissionStatusEnumMap = {
  MissionStatus.assigned: 'ASSIGNED',
  MissionStatus.started: 'STARTED',
  MissionStatus.paused: 'PAUSED',
  MissionStatus.completed: 'COMPLETED',
  MissionStatus.skipped: 'SKIPPED',
};

const _$MissionDifficultyEnumMap = {
  MissionDifficulty.veryEasy: 'VERY_EASY',
  MissionDifficulty.easy: 'EASY',
  MissionDifficulty.normal: 'NORMAL',
  MissionDifficulty.hard: 'HARD',
  MissionDifficulty.veryHard: 'VERY_HARD',
};

const _$MissionCategoryEnumMap = {
  MissionCategory.relationship: 'RELATIONSHIP',
  MissionCategory.health: 'HEALTH',
  MissionCategory.work: 'WORK',
  MissionCategory.hobby: 'HOBBY',
  MissionCategory.study: 'STUDY',
};

MissionData _$MissionDataFromJson(Map<String, dynamic> json) => MissionData(
  userId: (json['userId'] as num).toInt(),
  missions:
      (json['missions'] as List<dynamic>)
          .map((e) => Mission.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$MissionDataToJson(MissionData instance) =>
    <String, dynamic>{'userId': instance.userId, 'missions': instance.missions};

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) =>
    ApiError(code: json['code'] as String, message: json['message'] as String);

Map<String, dynamic> _$ApiErrorToJson(ApiError instance) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
};

MissionResponse _$MissionResponseFromJson(Map<String, dynamic> json) =>
    MissionResponse(
      timestamp: json['timestamp'] as String,
      success: json['success'] as bool,
      message: json['message'] as String,
      data:
          json['data'] == null
              ? null
              : MissionData.fromJson(json['data'] as Map<String, dynamic>),
      error:
          json['error'] == null
              ? null
              : ApiError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MissionResponseToJson(MissionResponse instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'error': instance.error,
    };
