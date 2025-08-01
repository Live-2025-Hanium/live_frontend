class SaeipUser {
  final String nickname;
  final String gender;
  final DateTime birthDate;
  final String job;
  final String? profileImageUrl;
  final DateTime? lastSurveyDate; // 마지막 설문 일자
  final String? isolationTendency; // 고립 은둔 경향
  final int? isolationLevel; // 고립 은둔 정도 (예: 1~5 척도)

  const SaeipUser({
    required this.nickname,
    required this.gender,
    required this.birthDate,
    required this.job,
    this.profileImageUrl,
    this.lastSurveyDate,
    this.isolationTendency,
    this.isolationLevel,
  });

  factory SaeipUser.fromFormData(Map<String, dynamic> data) {
    final birthDate = DateTime(
      data['year'],
      data['month'],
      data['day'],
    );
    return SaeipUser(
      nickname: data['nickname'],
      gender: data['gender'],
      birthDate: birthDate,
      job: data['job'],
    );
  }

  factory SaeipUser.fromJson(Map<String, dynamic> json) {
    return SaeipUser(
      nickname: json['nickname'],
      gender: json['gender'],
      birthDate: DateTime.parse(json['birthDate']),
      job: json['job'],
      profileImageUrl: json['profileImageUrl'],
      lastSurveyDate: json['lastSurveyDate'] != null
          ? DateTime.parse(json['lastSurveyDate'])
          : null,
      isolationTendency: json['isolationTendency'],
      isolationLevel: json['isolationLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'gender': gender,
      'birthDate':
          '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}',
      'job': job,
      'profileImageUrl': profileImageUrl,
      'lastSurveyDate': lastSurveyDate?.toIso8601String(),
      'isolationTendency': isolationTendency,
      'isolationLevel': isolationLevel,
    };
  }

  SaeipUser copyWith({
    String? nickname,
    String? gender,
    DateTime? birthDate,
    String? job,
    String? profileImageUrl,
    DateTime? lastSurveyDate,
    String? isolationTendency,
    int? isolationLevel,
  }) {
    return SaeipUser(
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      job: job ?? this.job,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      lastSurveyDate: lastSurveyDate ?? this.lastSurveyDate,
      isolationTendency: isolationTendency ?? this.isolationTendency,
      isolationLevel: isolationLevel ?? this.isolationLevel,
    );
  }

  @override
  String toString() =>
      'SaeipUser(nickname: $nickname, gender: $gender, birthDate: $birthDate, job: $job, profileImageUrl: $profileImageUrl, lastSurveyDate: $lastSurveyDate, isolationTendency: $isolationTendency, isolationLevel: $isolationLevel)';
}
