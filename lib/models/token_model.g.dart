// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenModel _$TokenModelFromJson(Map<String, dynamic> json) => TokenModel(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  accessTokenExpiresAt: DateTime.parse(json['accessTokenExpiresAt'] as String),
  refreshTokenExpiresAt: DateTime.parse(
    json['refreshTokenExpiresAt'] as String,
  ),
);

Map<String, dynamic> _$TokenModelToJson(TokenModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'accessTokenExpiresAt': instance.accessTokenExpiresAt.toIso8601String(),
      'refreshTokenExpiresAt': instance.refreshTokenExpiresAt.toIso8601String(),
    };
