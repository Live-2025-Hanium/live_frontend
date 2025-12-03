import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/controllers/survey_controller.dart';
import 'package:live_frontend/models/survey_question_model.dart';

final surveyQuestionsProvider = FutureProvider.family<PaginationModel, int>((
  ref,
  page,
) {
  final controller = ref.read(surveyControllerProvider);
  return controller.fetchSurveyQuestions(page);
});
