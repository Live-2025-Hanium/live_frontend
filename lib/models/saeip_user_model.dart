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

/// 서버에서 "MALE" / "FEMALE" / 그 외가 올 수 있다고 가정
enum Gender {
  @JsonValue('MALE')
  male,
  @JsonValue('FEMALE')
  female,
  @JsonValue('OTHER')
  other,
  // 정의 밖 값이 오면 여기로 파싱됨
  unknown,
}

@JsonSerializable()
class LoginData {
  final SaeipUserModel user;

  @JsonKey(defaultValue: '')
  final String accessToken;

  @JsonKey(defaultValue: '')
  final String refreshToken;

  @JsonKey(name: 'newUser', defaultValue: false)
  final bool newUser;

  LoginData({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.newUser,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}

/// 사용자 모델
@JsonSerializable()
class SaeipUserModel {
  final int id;

  final String email;
  final String nickname;

  /// 프로필 이미지 URL (nullable)
  final String? profileImageUrl;

  final SaeipUserType role;

  SaeipUserModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    required this.role,
  });

  factory SaeipUserModel.fromJson(Map<String, dynamic> json) =>
      _$SaeipUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaeipUserModelToJson(this);
}

/// 웹 로그인 응답 루트 모델
@JsonSerializable(explicitToJson: true)
class WebLoginModel {
  final TokenModel token;
  final WebUserModel user;

  const WebLoginModel({required this.token, required this.user});

  factory WebLoginModel.fromJson(Map<String, dynamic> json) =>
      _$WebLoginModelFromJson(json);
  Map<String, dynamic> toJson() => _$WebLoginModelToJson(this);
}

/// 액세스/리프레시 토큰 + 만료 정보(초 단위)
@JsonSerializable()
class TokenModel {
  final String accessToken;
  final String refreshToken;
  final int accessTokenExpiresIn; // seconds
  final int refreshTokenExpiresIn; // seconds

  const TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresIn,
    required this.refreshTokenExpiresIn,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}

/// 사용자 정보
@JsonSerializable()
class WebUserModel {
  final int userId;
  final String email;
  final String nickname;
  final String? profileImageUrl;
  @JsonKey(unknownEnumValue: Gender.unknown)
  final Gender gender;
  final int age;
  final bool isOnboarded;

  const WebUserModel({
    required this.userId,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    required this.gender,
    required this.age,
    required this.isOnboarded,
  });

  factory WebUserModel.fromJson(Map<String, dynamic> json) =>
      _$WebUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$WebUserModelToJson(this);
}
