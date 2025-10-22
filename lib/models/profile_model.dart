import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final int id;
  final String nickname;
  final String? profileImageUrl;
  final String? gender;
  final String? birthDate;
  final String? occupation;
  final String? occupationDetail;
  final String? lastSurveySubmittedAt;

  ProfileModel({
    required this.id,
    required this.nickname,
    this.profileImageUrl,
    this.gender,
    this.birthDate,
    this.occupation,
    this.occupationDetail,
    this.lastSurveySubmittedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

@JsonSerializable()
class NicknameDuplicationCheckModel {
  final bool available;
  final String message;

  NicknameDuplicationCheckModel({
    required this.available,
    required this.message,
  });

  factory NicknameDuplicationCheckModel.fromJson(Map<String, dynamic> json) =>
      _$NicknameDuplicationCheckModelFromJson(json);
  Map<String, dynamic> toJson() => _$NicknameDuplicationCheckModelToJson(this);
}

class NicknameDuplicationCheckResponse {
  final String message;
  final bool available;

  NicknameDuplicationCheckResponse({
    required this.message,
    required this.available,
  });
}
