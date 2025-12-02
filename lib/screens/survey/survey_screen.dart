import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/survey_question_model.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:live_frontend/providers/survey_provider.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class SurveyScreen extends ConsumerStatefulWidget {
  const SurveyScreen({super.key});

  @override
  ConsumerState<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends ConsumerState<SurveyScreen>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  int _currentPage = 0;
  int _totalPages = 1; // 초기값을 1로 설정하여 0으로 나누는 오류 방지
  final List<SurveyAnswerModel> _answers = [];
  List<SurveyQuestionModel> _questions = []; // 로컬 캐시된 질문 목록

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  void goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageViewController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _dialogBuilder(context);
    }
  }

  void goToPrevPage() {
    if (_currentPage > 0) {
      _pageViewController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool isAllSelected(List<SurveyAnswerModel> answers) {
    for (var answer in answers) {
      if (answer.answerNumber == null && answer.answerNumbers == null) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(surveyQuestionsProvider);
    bool allSelected = isAllSelected(_answers);
    int progress = allSelected ? _currentPage + 1 : _currentPage;

    return Scaffold(
      appBar: SaeipAppBar(onBack: _currentPage > 0 ? goToPrevPage : null),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
        child: SafeArea(
          child: Column(
            children: [
              _buildUserInfoWidget(),
              const Gap(16),
              LinearPercentIndicator(
                padding: EdgeInsets.only(left: 0, right: 10),
                width: 300,
                animation: true,
                animationDuration: 1000,
                lineHeight: 2.0,
                trailing: Text(
                  '$progress / $_totalPages',
                  style: AppTextStyles.smallMedium(
                    context,
                    color: AppColors.blackBlack5,
                  ),
                ),
                percent: _totalPages == 0 ? 0 : progress / _totalPages,
                progressColor: AppColors.greenNormal,
              ),
              const Gap(16),
              Expanded(
                child: questionsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('오류: $error')),
                  data: (questionsFromProvider) {
                    // 프로바이더로부터 받은 데이터로 로컬 상태를 한 번만 초기화합니다.
                    if (_questions.isEmpty &&
                        questionsFromProvider.questions.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          _questions = questionsFromProvider.questions;
                          _totalPages =
                              (questionsFromProvider.questions.length / 4)
                                  .ceil();
                        });
                      });
                    }

                    if (_questions.isEmpty) {
                      // 아직 데이터가 설정되지 않았으면 로딩 상태를 표시합니다.
                      return const Center(child: CircularProgressIndicator());
                    }

                    return PageView.builder(
                      controller: _pageViewController,
                      itemCount: _totalPages,
                      physics: const NeverScrollableScrollPhysics(), // 버튼으로만 이동
                      itemBuilder: (context, pageIndex) {
                        final startIndex = pageIndex * 4;
                        final endIndex = (startIndex + 4).clamp(
                          0,
                          _questions.length,
                        );
                        final questionsForPage = _questions.sublist(
                          startIndex,
                          endIndex,
                        );

                        return ListView.builder(
                          itemCount: questionsForPage.length,
                          padding: EdgeInsets.only(top: 8, bottom: 24),
                          itemBuilder: (context, index) {
                            final question = questionsForPage[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: questionBlock(question),
                            );
                          },
                        );
                      },
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    );
                  },
                ),
              ),
              const Gap(16),
              SizedBox(
                width: double.infinity,
                child: SaeipButton(
                  text: _currentPage + 1 == _totalPages ? '제출' : '다음',
                  onPressed: goToNextPage,
                  disabled: !allSelected,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                text: " 님에 대해\n 알려주세요!",
                style: AppTextStyles.subtitleMedium(
                  context,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // 질문 위젯 (객관식 선택)
  Widget questionBlock(SurveyQuestionModel question) {
    final answer = _answers.firstWhere(
      (ans) => ans.questionNumber == question.questionNumber,
      orElse: () => SurveyAnswerModel(
        questionNumber: question.questionNumber,
        answerNumber: null,
        answerNumbers: null,
        multipleChoice: question.questionType == QuestionType.multipleChoice,
        singleChoice: question.questionType == QuestionType.singleChoice,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${question.questionText} (${question.questionType.koreanLabel})',
          style: AppTextStyles.bodyRegular(context, color: Colors.black),
        ),
        const Gap(8),
        Column(
          children: question.options.map((option) {
            final isSelected =
                question.questionType == QuestionType.singleChoice
                ? answer.answerNumber == option.optionNumber
                : (answer.answerNumbers?.contains(option.optionNumber) ??
                      false);

            return optionTile(option, isSelected, (value) {
              setState(() {
                final existingIndex = _answers.indexWhere(
                  (ans) => ans.questionNumber == question.questionNumber,
                );
                final existing = existingIndex >= 0
                    ? _answers[existingIndex]
                    : null;

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

                  if (existingIndex >= 0) {
                    _answers[existingIndex] = newAnswer;
                  } else {
                    _answers.add(newAnswer);
                  }
                } else {
                  final List<int> newAnswerNumbers =
                      (existing?.answerNumbers != null)
                      ? List<int>.from(existing!.answerNumbers!)
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

                  if (existingIndex >= 0) {
                    _answers[existingIndex] = newAnswer;
                  } else {
                    _answers.add(newAnswer);
                  }
                }
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

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SaeipModal(
          title: "잠깐!",
          message: "제출 이후 답변을 수정할 수 없어요.",
          onConfirm: () => context.goNamed('home'),
          confirmText: "제출",
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
