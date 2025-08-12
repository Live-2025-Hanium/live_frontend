// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_mission_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyMissionModel _$MyMissionModelFromJson(Map<String, dynamic> json) =>
    MyMissionModel(
      myMissionId: (json['myMissionId'] as num).toInt(),
      missionTitle: json['missionTitle'] as String,
      startDate: _dateFromYMD(json['startDate'] as String),
      endDate: _dateFromYMD(json['endDate'] as String),
      scheduledTime: (json['scheduledTime'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      repeatDays: (json['repeatDays'] as List<dynamic>)
          .map((e) => $enumDecode(_$RepeatDayEnumMap, e))
          .toList(),
      active: json['active'] as bool,
    );

Map<String, dynamic> _$MyMissionModelToJson(
  MyMissionModel instance,
) => <String, dynamic>{
  'myMissionId': instance.myMissionId,
  'missionTitle': instance.missionTitle,
  'startDate': _dateToYMD(instance.startDate),
  'endDate': _dateToYMD(instance.endDate),
  'scheduledTime': instance.scheduledTime,
  'repeatDays': instance.repeatDays.map((e) => _$RepeatDayEnumMap[e]!).toList(),
  'active': instance.active,
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
