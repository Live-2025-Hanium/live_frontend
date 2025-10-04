// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyMissionModel _$MyMissionModelFromJson(Map<String, dynamic> json) =>
    MyMissionModel(
      userMissionId: (json['userMissionId'] as num).toInt(),
      missionTitle: json['missionTitle'] as String,
      myMissionStatus: $enumDecode(
        _$MissionStatusEnumMap,
        json['myMissionStatus'],
      ),
      scheduledTime: json['scheduledTime'] as String?,
      repeatType: $enumDecodeNullable(_$RepeatDayEnumMap, json['repeatType']),
    );

Map<String, dynamic> _$MyMissionModelToJson(MyMissionModel instance) =>
    <String, dynamic>{
      'userMissionId': instance.userMissionId,
      'missionTitle': instance.missionTitle,
      'myMissionStatus': _$MissionStatusEnumMap[instance.myMissionStatus]!,
      'scheduledTime': instance.scheduledTime,
      'repeatType': _$RepeatDayEnumMap[instance.repeatType],
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

MyMissionAddPayloadModel _$MyMissionAddPayloadModelFromJson(
  Map<String, dynamic> json,
) => MyMissionAddPayloadModel(
  missionTitle: json['missionTitle'] as String,
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  scheduledTime: json['scheduledTime'] as String?,
  repeatDay: $enumDecodeNullable(_$RepeatDayEnumMap, json['repeatDay']),
);

Map<String, dynamic> _$MyMissionAddPayloadModelToJson(
  MyMissionAddPayloadModel instance,
) => <String, dynamic>{
  'missionTitle': instance.missionTitle,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'scheduledTime': instance.scheduledTime,
  'repeatDay': _$RepeatDayEnumMap[instance.repeatDay],
};
