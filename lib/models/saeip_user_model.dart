import 'package:json_annotation/json_annotation.dart';

part 'saeip_user_model.g.dart';

/// 사용자 모델 및 로그인 응답 모델을 함께 정의합니다.

/// 사용자 역할 타입
enum SaeipUserType {
  @JsonValue('USER')
  user,
  @JsonValue('ADMIN')
  admin,
}

/// 로그인 API 응답의 최상위 모델
@JsonSerializable()
class LoginResponse {
  final LoginData data;

  LoginResponse({required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

/// 로그인 응답의 data 필드
@JsonSerializable()
class LoginData {
  final SaeipUserModel user;
  @JsonKey(name: 'newUser', defaultValue: false)
  final bool newUser;

  LoginData({required this.user, required this.newUser});

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

/// 사용자 모델
@JsonSerializable()
class SaeipUserModel {
  final int id;

  /// OAuth 구분자 (예: "google_12345", "kakao_67890").
  @JsonKey(defaultValue: '')
  final String oauthId;

  final String email;
  final String nickname;

  /// 프로필 이미지 URL (nullable)
  final String? profileImageUrl;

  final SaeipUserType role;

  SaeipUserModel({
    required this.id,
    required this.oauthId,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    required this.role,
  });

  factory SaeipUserModel.fromJson(Map<String, dynamic> json) =>
      _$SaeipUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaeipUserModelToJson(this);
}
