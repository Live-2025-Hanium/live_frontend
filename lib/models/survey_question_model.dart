class SurveyQuestionModel {
  int? questionNumber;
  String? question;
  int? response;

  SurveyQuestionModel({this.questionNumber, this.question, this.response});

  SurveyQuestionModel.fromJson(Map<String, dynamic> json) {
    questionNumber = json['questionNumber'];
    question = json['question'];
  }

  Map<String, dynamic> toAnswerJson() {
    return {
      'questionNumber': questionNumber,
      'answerNumber': response != null ? response! + 1 : null,
    };
  }

  SurveyQuestionModel copyWith({int? response}) {
    return SurveyQuestionModel(
      questionNumber: questionNumber,
      question: question,
      response: response ?? this.response,
    );
  }
}
