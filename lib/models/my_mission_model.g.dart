// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyMissionModel _$MyMissionModelFromJson(Map<String, dynamic> json) =>
    MyMissionModel(
      userMissionId: (json['userMissionId'] as num).toInt(),
      missionType: $enumDecode(_$MissionTypeEnumMap, json['missionType']),
      missionTitle: json['missionTitle'] as String,
      missionStatus: $enumDecode(_$MissionStatusEnumMap, json['missionStatus']),
      scheduledTime: json['scheduledTime'] as String,
      repeatDay: $enumDecode(_$RepeatDayEnumMap, json['repeatDay']),
    );

Map<String, dynamic> _$MyMissionModelToJson(MyMissionModel instance) =>
    <String, dynamic>{
      'userMissionId': instance.userMissionId,
      'missionType': _$MissionTypeEnumMap[instance.missionType]!,
      'missionTitle': instance.missionTitle,
      'missionStatus': _$MissionStatusEnumMap[instance.missionStatus]!,
      'scheduledTime': instance.scheduledTime,
      'repeatDay': _$RepeatDayEnumMap[instance.repeatDay]!,
    };

const _$MissionTypeEnumMap = {
  MissionType.my: 'MY',
  MissionType.clover: 'CLOVER',
};

const _$MissionStatusEnumMap = {
  MissionStatus.assigned: 'ASSIGNED',
  MissionStatus.started: 'STARTED',
  MissionStatus.paused: 'PAUSED',
  MissionStatus.completed: 'COMPLETED',
  MissionStatus.skipped: 'SKIPPED',
};

const _$RepeatDayEnumMap = {
  RepeatDay.monday: 'MONDAY',
  RepeatDay.tuesday: 'TUESDAY',
  RepeatDay.wednesday: 'WEDNESDAY',
  RepeatDay.thursday: 'THURSDAY',
  RepeatDay.friday: 'FRIDAY',
  RepeatDay.saturday: 'SATURDAY',
  RepeatDay.sunday: 'SUNDAY',
  RepeatDay.everyday: 'EVERYDAY',
  RepeatDay.weekdays: 'WEEKDAYS',
  RepeatDay.weekend: 'WEEKEND',
};

MyMissionAddModel _$MyMissionAddModelFromJson(Map<String, dynamic> json) =>
    MyMissionAddModel(
      missionTitle: json['missionTitle'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      scheduledTime: json['scheduledTime'] as String?,
      repeatDay: $enumDecodeNullable(_$RepeatDayEnumMap, json['repeatDay']),
    );

Map<String, dynamic> _$MyMissionAddModelToJson(MyMissionAddModel instance) =>
    <String, dynamic>{
      'missionTitle': instance.missionTitle,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'scheduledTime': instance.scheduledTime,
      'repeatDay': _$RepeatDayEnumMap[instance.repeatDay],
    };
