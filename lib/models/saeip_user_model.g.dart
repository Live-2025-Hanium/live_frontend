// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saeip_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      data: LoginData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{'data': instance.data};

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
  user: SaeipUserModel.fromJson(json['user'] as Map<String, dynamic>),
  newUser: json['newUser'] as bool? ?? false,
);

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
  'user': instance.user,
  'newUser': instance.newUser,
};

SaeipUserModel _$SaeipUserModelFromJson(Map<String, dynamic> json) =>
    SaeipUserModel(
      id: (json['id'] as num).toInt(),
      oauthId: json['oauthId'] as String? ?? '',
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      role: $enumDecode(_$SaeipUserTypeEnumMap, json['role']),
    );

Map<String, dynamic> _$SaeipUserModelToJson(SaeipUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'oauthId': instance.oauthId,
      'email': instance.email,
      'nickname': instance.nickname,
      'profileImageUrl': instance.profileImageUrl,
      'role': _$SaeipUserTypeEnumMap[instance.role]!,
    };

const _$SaeipUserTypeEnumMap = {
  SaeipUserType.user: 'USER',
  SaeipUserType.admin: 'ADMIN',
};
