// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saeip_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
  user: SaeipUserModel.fromJson(json['user'] as Map<String, dynamic>),
  accessToken: json['accessToken'] as String? ?? '',
  refreshToken: json['refreshToken'] as String? ?? '',
  newUser: json['newUser'] as bool? ?? false,
);

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
  'user': instance.user,
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'newUser': instance.newUser,
};

SaeipUserModel _$SaeipUserModelFromJson(Map<String, dynamic> json) =>
    SaeipUserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      role: $enumDecode(_$SaeipUserTypeEnumMap, json['role']),
    );

Map<String, dynamic> _$SaeipUserModelToJson(SaeipUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'role': _$SaeipUserTypeEnumMap[instance.role]!,
    };

const _$SaeipUserTypeEnumMap = {
  SaeipUserType.user: 'USER',
  SaeipUserType.admin: 'ADMIN',
};
