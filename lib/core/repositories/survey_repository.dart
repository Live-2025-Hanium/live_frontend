import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/models/survey_question_model.dart';
import 'package:live_frontend/providers/dio_provider.dart';

final surveyRepositoryProvider = Provider<SurveyRepository>((ref) {
  final dio = ref.read(dioProvider);
  return SurveyRepository(dio);
});

class SurveyRepository {
  final Dio _dio;
  SurveyRepository(this._dio);
  Future<PaginationModel> getSurveyQuestions(int page) async {
    try {
      final response = await _dio.get(
        '/api/v1/survey/questions',
        queryParameters: {'page': page},
      );

      final apiResponse = ApiResponseModel<PaginationModel>.fromJson(
        response.data,
        (json) => PaginationModel.fromJson(json as Map<String, dynamic>),
      );
      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(
          'Error: ${apiResponse.error?.code ?? 'Unknown'} - ${apiResponse.error?.message ?? 'No message'}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load survey questions');
    }
  }

  Future<void> postSurveyAnswers(List<SurveyAnswerModel> answers) async {
    try {
      final answersJson = answers.map((answer) => answer.toJson()).toList();
      final response = await _dio.post(
        '/api/v1/surveys/submit',
        data: {'answers': answersJson},
      );

      final apiResponse = ApiResponseModel<void>.fromJson(
        response.data,
        (_) {},
      );
      if (!apiResponse.success) {
        throw Exception(
          'Error: ${apiResponse.error?.code ?? 'Unknown'} - ${apiResponse.error?.message ?? 'No message'}',
        );
      }
    } catch (e) {
      throw Exception('Failed to submit survey answers');
    }
  }
}
