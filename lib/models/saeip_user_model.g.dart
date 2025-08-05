// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saeip_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaeipUserModel _$SaeipUserModelFromJson(Map<String, dynamic> json) =>
    SaeipUserModel(
      id: json['id'] as String,
      oauthId: json['oauthId'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      role: $enumDecode(_$SaeipUserTypeEnumMap, json['role']),
      isNewUser: json['isNewUser'] as bool,
    );

Map<String, dynamic> _$SaeipUserModelToJson(SaeipUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'oauthId': instance.oauthId,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'role': _$SaeipUserTypeEnumMap[instance.role]!,
      'isNewUser': instance.isNewUser,
    };

const _$SaeipUserTypeEnumMap = {
  SaeipUserType.user: 'USER',
  SaeipUserType.admin: 'ADMIN',
};
