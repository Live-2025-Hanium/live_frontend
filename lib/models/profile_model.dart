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

enum Occupation { student, employee, homemaker, freelancer, unemployed, other }

extension OccupationExtension on Occupation {
  String get description {
    switch (this) {
      case Occupation.student:
        return "학생";
      case Occupation.employee:
        return "직장인";
      case Occupation.homemaker:
        return "주부";
      case Occupation.freelancer:
        return "프리랜서/자영업";
      case Occupation.unemployed:
        return "무직/구직 중";
      case Occupation.other:
        return "기타(직접 입력)";
    }
  }

  String get value {
    switch (this) {
      case Occupation.student:
        return "STUDENT";
      case Occupation.employee:
        return "EMPLOYEE";
      case Occupation.homemaker:
        return "HOMEMAKER";
      case Occupation.freelancer:
        return "FREELANCER";
      case Occupation.unemployed:
        return "UNEMPLOYED";
      case Occupation.other:
        return "OTHER";
    }
  }
}

enum Gender { male, female, other }

extension GenderExtension on Gender {
  String get description {
    switch (this) {
      case Gender.male:
        return "남성";
      case Gender.female:
        return "여성";
      case Gender.other:
        return "기타";
    }
  }

  String get value {
    switch (this) {
      case Gender.male:
        return "MALE";
      case Gender.female:
        return "FEMALE";
      case Gender.other:
        return "OTHER";
    }
  }
}

@JsonSerializable()
class ProfileUpdatePayloadModel {
  final String nickname;
  final String? profileImageUrl;
  final String gender;
  final int birthYear;
  final int birthMonth;
  final int birthDay;
  final String occupation;
  final String? occupationDetail;

  ProfileUpdatePayloadModel({
    required this.nickname,
    this.profileImageUrl,
    required this.gender,
    required this.birthYear,
    required this.birthMonth,
    required this.birthDay,
    required this.occupation,
    this.occupationDetail,
  });

  factory ProfileUpdatePayloadModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileUpdatePayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileUpdatePayloadModelToJson(this);
}
