import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/core/controllers/survey_controller.dart';
import 'package:live_frontend/models/survey_question_model.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:live_frontend/providers/survey_provider.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';

class SurveyScreen extends ConsumerStatefulWidget {
  const SurveyScreen({super.key});

  @override
  ConsumerState<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends ConsumerState<SurveyScreen> {
  int _currentPage = 0;
  int _totalPages = 1;
  final Map<int, SurveyAnswerModel> _answers = {};
  bool allSelected = false;

  void goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
    } else {
      _dialogBuilder(context);
    }
  }

  void goToPrevPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  bool isAllSelected(Map<int, SurveyAnswerModel> answers) {
    for (var answer in answers.values) {
      if (answer.answerNumber == null && answer.answerNumbers == null) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(surveyQuestionsProvider(_currentPage + 1));

    return Scaffold(
      appBar: SaeipAppBar(onBack: _currentPage > 0 ? goToPrevPage : null),
      body: Container(
        padding: const EdgeInsets.only(bottom: 40),
        child: SafeArea(
          child: Column(
            children: [
              _buildUserInfoWidget(),
              const Gap(28),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 16),
                  child: questionsAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(child: Text('오류: $error')),
                    data: (questionsFromProvider) {
                      // Ensure total pages is taken from the provider
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _totalPages = questionsFromProvider.totalPages;
                          });
                        }
                      });

                      final questions = questionsFromProvider.questions;
                      if (questions.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return ListView.builder(
                        itemCount: questions.length,
                        padding: EdgeInsets.only(top: 8, bottom: 24),
                        itemBuilder: (context, index) {
                          final question = questions[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: questionBlock(question),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              const Gap(16),

              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  child: SaeipButton(
                    text: _currentPage + 1 == _totalPages ? '제출' : '다음',
                    onPressed: goToNextPage,
                    disabled: !allSelected,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoWidget() {
    final userName = ref.watch(authProvider).nickname ?? "사용자";
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.greenNormal, width: 1.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: userName,
                  style: AppTextStyles.subtitleMedium(
                    context,
                    color: AppColors.greenNormal,
                  ),
                ),
                TextSpan(
                  text: " 님에 대해 알려주세요!",
                  style: AppTextStyles.subtitleMedium(
                    context,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
        ],
      ),
    );
  }

  // 질문 위젯
  Widget questionBlock(SurveyQuestionModel question) {
    // 답 리스트에 들어가지 않았다면 새로 추가
    if (!_answers.containsKey(question.questionNumber)) {
      _answers[question.questionNumber] = SurveyAnswerModel(
        questionNumber: question.questionNumber,
        answerNumber: null,
        answerNumbers: null,
        multipleChoice: question.questionType == QuestionType.multipleChoice,
        singleChoice: question.questionType == QuestionType.singleChoice,
      );
    }

    final answer = _answers[question.questionNumber]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            '${question.questionText} (${question.questionType.koreanLabel})',
            style: AppTextStyles.bodyRegular(context, color: Colors.black),
          ),
        ),
        const Gap(8),
        Column(
          children: question.options.map((option) {
            final isSelected =
                // 객관식이면
                question.questionType == QuestionType.singleChoice
                ?
                  // 옵션넘버랑 헌택된 답변이랑 같으면 선택된거
                  answer.answerNumber == option.optionNumber
                :
                  // 다중선택이고 답변리스트에 옵션넘버가 있으면 선택된거
                  (answer.answerNumbers?.contains(option.optionNumber) ??
                      false); // 일단 혹시 모르니 false 반환

            return optionTile(option, isSelected, (value) {
              setState(() {
                if (question.questionType == QuestionType.singleChoice) {
                  final int? newAnswerNumber = value == true
                      ? option.optionNumber
                      : null;
                  final newAnswer = SurveyAnswerModel(
                    questionNumber: question.questionNumber,
                    answerNumber: newAnswerNumber,
                    answerNumbers: null,
                    multipleChoice:
                        question.questionType == QuestionType.multipleChoice,
                    singleChoice:
                        question.questionType == QuestionType.singleChoice,
                  );

                  _answers[question.questionNumber] = newAnswer;
                } else {
                  final List<int> newAnswerNumbers =
                      (answer.answerNumbers != null)
                      ? List<int>.from(answer.answerNumbers!)
                      : <int>[];

                  if (value == true) {
                    if (!newAnswerNumbers.contains(option.optionNumber)) {
                      newAnswerNumbers.add(option.optionNumber);
                    }
                  } else {
                    newAnswerNumbers.remove(option.optionNumber);
                  }

                  final newAnswer = SurveyAnswerModel(
                    questionNumber: question.questionNumber,
                    answerNumber: null,
                    answerNumbers: newAnswerNumbers.isEmpty
                        ? null
                        : newAnswerNumbers,
                    multipleChoice:
                        question.questionType == QuestionType.multipleChoice,
                    singleChoice:
                        question.questionType == QuestionType.singleChoice,
                  );

                  _answers[question.questionNumber] = newAnswer;
                }
                allSelected = isAllSelected(_answers);
              });
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget optionTile(
    SurveyOptionModel option,
    bool isSelected,
    Function(bool?) onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0.0,
      leading: SizedBox(
        height: 48,
        width: 48,
        child: Transform.scale(
          scale: 24 / 18,
          child: Checkbox(
            value: isSelected,
            onChanged: onChanged,
            activeColor: AppColors.greenNormal,
            checkColor: Colors.white,
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.greenNormal),
            ),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ),
      title: Text(
        option.optionText,
        style: AppTextStyles.bodyRegular(context, color: Colors.black),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    // final jsonList = _questions.map((q) => q.toAnswerJson()).toList();

    // log("응답 JSON", name: "Survey", error: jsonEncode(jsonList));

    // Capture the parent context so we can navigate after the dialog is closed.
    final parentContext = context;

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SaeipModal(
          title: "잠깐!",
          message: "제출 이후 답변을 수정할 수 없어요.",
          onConfirm: () {
            final List<SurveyAnswerModel> answers = _answers.values.toList()
              ..sort((a, b) => a.questionNumber.compareTo(b.questionNumber));

            Navigator.of(dialogContext).pop();

            ref
                .read(surveyControllerProvider)
                .submitSurveyAnswers(answers)
                .then((_) {
                  if (mounted) {
                    parentContext.goNamed('home');
                  }
                })
                .catchError((error) {
                  ScaffoldMessenger.of(
                    parentContext,
                  ).showSnackBar(SnackBar(content: Text('제출 실패: $error')));
                });
          },
          confirmText: "제출",
          onCancel: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
  }
}
