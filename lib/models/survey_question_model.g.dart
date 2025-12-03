// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SurveyQuestionModel _$SurveyQuestionModelFromJson(Map<String, dynamic> json) =>
    SurveyQuestionModel(
      id: (json['id'] as num).toInt(),
      questionNumber: (json['questionNumber'] as num).toInt(),
      questionText: json['questionText'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => SurveyOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      required: json['required'] as bool,
      questionType: $enumDecode(_$QuestionTypeEnumMap, json['questionType']),
    );

Map<String, dynamic> _$SurveyQuestionModelToJson(
  SurveyQuestionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'questionNumber': instance.questionNumber,
  'questionText': instance.questionText,
  'options': instance.options,
  'required': instance.required,
  'questionType': _$QuestionTypeEnumMap[instance.questionType]!,
};

const _$QuestionTypeEnumMap = {
  QuestionType.singleChoice: 'SINGLE_CHOICE',
  QuestionType.multipleChoice: 'MULTIPLE_CHOICE',
};

SurveyOptionModel _$SurveyOptionModelFromJson(Map<String, dynamic> json) =>
    SurveyOptionModel(
      id: (json['id'] as num).toInt(),
      optionNumber: (json['optionNumber'] as num).toInt(),
      optionText: json['optionText'] as String,
    );

Map<String, dynamic> _$SurveyOptionModelToJson(SurveyOptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'optionNumber': instance.optionNumber,
      'optionText': instance.optionText,
    };

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      questions: (json['questions'] as List<dynamic>)
          .map((e) => SurveyQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: (json['currentPage'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      questionsPerPage: (json['questionsPerPage'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
      hasPrevious: json['hasPrevious'] as bool,
      progressPercentage: (json['progressPercentage'] as num).toInt(),
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'questions': instance.questions,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'totalQuestions': instance.totalQuestions,
      'questionsPerPage': instance.questionsPerPage,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
      'progressPercentage': instance.progressPercentage,
    };

SurveyAnswerModel _$SurveyAnswerModelFromJson(Map<String, dynamic> json) =>
    SurveyAnswerModel(
      questionNumber: (json['questionNumber'] as num).toInt(),
      answerNumber: (json['answerNumber'] as num?)?.toInt(),
      answerNumbers: (json['answerNumbers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      multipleChoice: json['multipleChoice'] as bool,
      singleChoice: json['singleChoice'] as bool,
    );

Map<String, dynamic> _$SurveyAnswerModelToJson(SurveyAnswerModel instance) =>
    <String, dynamic>{
      'questionNumber': instance.questionNumber,
      'answerNumber': instance.answerNumber,
      'answerNumbers': instance.answerNumbers,
      'multipleChoice': instance.multipleChoice,
      'singleChoice': instance.singleChoice,
    };
