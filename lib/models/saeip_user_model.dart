import 'package:json_annotation/json_annotation.dart';

part 'saeip_user_model.g.dart';

enum SaeipUserType {
  @JsonValue('USER')
  user,
  @JsonValue('ADMIN')
  admin,
}

@JsonSerializable()
class SaeipUserModel {
  final String id;
  final String oauthId; // ex: google_1234567890
  final String email;
  final String nickname;
  final String? profileImageUrl; // null일 수도 있음
  final SaeipUserType role; // ex: USER, ADMIN
  final bool isNewUser; // 처음 가입한 사용자 여부

  SaeipUserModel({
    required this.id,
    required this.oauthId,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    required this.role,
    required this.isNewUser,
  });

  factory SaeipUserModel.fromJson(Map<String, dynamic> json) =>
      _$SaeipUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$SaeipUserModelToJson(this);
}
