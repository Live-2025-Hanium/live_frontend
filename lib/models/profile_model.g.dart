// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  id: (json['id'] as num).toInt(),
  nickname: json['nickname'] as String,
  profileImageUrl: json['profileImageUrl'] as String?,
  gender: json['gender'] as String?,
  birthDate: json['birthDate'] as String?,
  occupation: json['occupation'] as String?,
  occupationDetail: json['occupationDetail'] as String?,
  lastSurveySubmittedAt: json['lastSurveySubmittedAt'] as String?,
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'gender': instance.gender,
      'birthDate': instance.birthDate,
      'occupation': instance.occupation,
      'occupationDetail': instance.occupationDetail,
      'lastSurveySubmittedAt': instance.lastSurveySubmittedAt,
    };
