class SurveyQuestionModel {
  int? questionNumber;
  String? question;
  int? response;

  SurveyQuestionModel({this.questionNumber, this.question, this.response});

  SurveyQuestionModel.fromJson(Map<String, dynamic> json) {
    questionNumber = json['questionNumber'];
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['questionNumber'] = questionNumber;
    data['question'] = question;
    return data;
  }

  SurveyQuestionModel copyWith({int? response}) {
    return SurveyQuestionModel(
      questionNumber: questionNumber,
      question: question,
      response: response ?? this.response,
    );
  }
}
