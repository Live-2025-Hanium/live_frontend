import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/repositories/survey_repository.dart';
import 'package:live_frontend/models/survey_question_model.dart';

final surveyControllerProvider = Provider<SurveyController>((ref) {
  final repository = ref.read(surveyRepositoryProvider);
  return SurveyController(repository);
});

class SurveyController {
  final SurveyRepository _repository;

  SurveyController(this._repository);

  Future<PaginationModel> fetchSurveyQuestions(int page) async {
    return await _repository.getSurveyQuestions(page);
  }

  Future<void> submitSurveyAnswers(List<SurveyAnswerModel> answers) async {
    await _repository.postSurveyAnswers(answers);
  }
}
