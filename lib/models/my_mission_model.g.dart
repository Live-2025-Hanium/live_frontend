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
      repeatDays: (json['repeatDays'] as List<dynamic>)
          .map((e) => $enumDecode(_$RepeatDayEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$MyMissionModelToJson(
  MyMissionModel instance,
) => <String, dynamic>{
  'userMissionId': instance.userMissionId,
  'missionType': _$MissionTypeEnumMap[instance.missionType]!,
  'missionTitle': instance.missionTitle,
  'missionStatus': _$MissionStatusEnumMap[instance.missionStatus]!,
  'scheduledTime': instance.scheduledTime,
  'repeatDays': instance.repeatDays.map((e) => _$RepeatDayEnumMap[e]!).toList(),
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
};
