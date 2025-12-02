import 'package:json_annotation/json_annotation.dart';

part 'survey_question_model.g.dart';

@JsonEnum(alwaysCreate: true)
enum QuestionType {
  @JsonValue('SINGLE_CHOICE')
  singleChoice,
  @JsonValue('MULTIPLE_CHOICE')
  multipleChoice,
}

extension QuestionTypeExtension on QuestionType {
  String get koreanLabel {
    switch (this) {
      case QuestionType.singleChoice:
        return '단일 선택';
      case QuestionType.multipleChoice:
        return '복수 선택';
    }
  }
}

@JsonSerializable()
class SurveyQuestionModel {
  final int id;
  final int questionNumber;
  final String questionText;
  final List<SurveyOptionModel> options;
  final bool required;
  final QuestionType questionType;

  SurveyQuestionModel({
    required this.id,
    required this.questionNumber,
    required this.questionText,
    required this.options,
    required this.required,
    required this.questionType,
  });

  factory SurveyQuestionModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyQuestionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SurveyQuestionModelToJson(this);
}

@JsonSerializable()
class SurveyOptionModel {
  final int id;
  final int optionNumber;
  final String optionText;
  SurveyOptionModel({
    required this.id,
    required this.optionNumber,
    required this.optionText,
  });
  factory SurveyOptionModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SurveyOptionModelToJson(this);
}

@JsonSerializable()
class PaginationModel {
  final List<SurveyQuestionModel> questions;
  final int currentPage;
  final int totalPages;
  final int totalQuestions;
  final int questionsPerPage;
  final bool hasNext;
  final bool hasPrevious;
  final int progressPercentage;

  PaginationModel({
    required this.questions,
    required this.currentPage,
    required this.totalPages,
    required this.totalQuestions,
    required this.questionsPerPage,
    required this.hasNext,
    required this.hasPrevious,
    required this.progressPercentage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}

@JsonSerializable()
class SurveyAnswerModel {
  final int questionNumber;
  final int? answerNumber;
  final List<int>? answerNumbers;
  final bool multipleChoice;
  final bool singleChoice;

  SurveyAnswerModel({
    required this.questionNumber,
    this.answerNumber,
    this.answerNumbers,
    required this.multipleChoice,
    required this.singleChoice,
  });

  factory SurveyAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyAnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyAnswerModelToJson(this);
}
