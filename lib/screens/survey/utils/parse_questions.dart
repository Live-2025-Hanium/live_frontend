import 'dart:convert';
import 'package:live_frontend/models/survey_question_model.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<SurveyQuestionModel>> loadQuestionsFromAssets() async {
  final String jsonStr = await rootBundle.loadString(
    'assets/surveys/temporal_questions.json',
  );
  final List<dynamic> jsonList = jsonDecode(jsonStr);
  return jsonList.map((e) => SurveyQuestionModel.fromJson(e)).toList();
}
