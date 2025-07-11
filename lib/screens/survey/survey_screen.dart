import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/survey_question_model.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:live_frontend/screens/survey/utils/parse_questions.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/widgets/saeip_toast.dart';
import 'package:live_frontend/widgets/utils/show_saeip_toast.dart';
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
  int _totalPages = 5;
  late final Future<List<SurveyQuestionModel>> _questionsFuture =
      loadQuestionsFromAssets().then((questions) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _totalPages = (questions.length / 4).ceil();
          });
        });
        return questions;
      });

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

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.only(left: 0, right: 10.w),
                width: 300.w,
                animation: true,
                animationDuration: 1000,
                lineHeight: 2.0,
                trailing: Text(
                  '$_currentPage / $_totalPages',
                  style: AppTextStyles.smallMedium(
                    context,
                    color: AppColors.blackBlack5,
                  ),
                ),
                percent: _totalPages == 0 ? 0 : _currentPage / _totalPages,
                progressColor: AppColors.greenNormal,
              ),
              const Gap(16),
              Expanded(
                child: FutureBuilder<List<SurveyQuestionModel>>(
                  future: _questionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('오류: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('질문 없음'));
                    }

                    final questions = snapshot.data!;
                    final totalPages = (questions.length / 4).ceil();

                    return PageView.builder(
                      controller: _pageViewController,
                      itemCount: totalPages,
                      physics: const NeverScrollableScrollPhysics(), // 버튼으로만 이동
                      itemBuilder: (context, pageIndex) {
                        final startIndex = pageIndex * 4;
                        final endIndex = (startIndex + 4).clamp(
                          0,
                          questions.length,
                        );
                        final questionsForPage = questions.sublist(
                          startIndex,
                          endIndex,
                        );

                        return ListView.builder(
                          itemCount: questionsForPage.length,
                          padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
                          itemBuilder: (context, index) {
                            final question = questionsForPage[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24.0),
                              child: _buildLikertSelector(
                                context: context,
                                question: question.question ?? "",
                                selectedIndex: question.response ?? -1,
                                onChanged: (selected) {
                                  setState(() {
                                    question.response = selected;
                                  });
                                },
                              ),
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
                child: SaeipButton(text: '다음', onPressed: goToNextPage),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoWidget() {
    final userName = ref.watch(authProvider).user?.name ?? "사용자";
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

  Widget _buildLikertSelector({
    required BuildContext context,
    required String question,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
  }) {
    List<(Color color, Color borderColor)> colors = [
      (AppColors.pinkNormal, AppColors.pinkLightActive),
      (AppColors.pinkNormal, AppColors.pinkLightActive),
      (AppColors.blackBlack3, AppColors.blackBlack2),
      (AppColors.greenNormal, AppColors.greenLightActive),
      (AppColors.greenNormal, AppColors.greenLightActive),
    ];

    List<double> widths = [48.w, 36.w, 28.w, 36.w, 48.w];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          question,
          style: AppTextStyles.subtitleMedium(context),
          textAlign: TextAlign.start,
        ),
        const Gap(15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: List.generate(5, (i) {
              return Padding(
                padding: EdgeInsets.only(
                  right:
                      i == 0
                          ? 24.w
                          : i == 1
                          ? 16.w
                          : 0,
                  left:
                      i == 4
                          ? 24.w
                          : i == 3
                          ? 16.w
                          : 0,
                ),
                child: _buildCustomRadioButton(
                  width: widths[i],
                  height: widths[i],
                  color: colors[i].$1,
                  borderColor: colors[i].$2,
                  isSelected: selectedIndex == i,
                  onChanged: () => onChanged(i),
                ),
              );
            }),
          ),
        ),
        Gap(5.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '아니오',
                style: AppTextStyles.smallMedium(
                  context,
                  color: AppColors.blackBlack5,
                ),
              ),
              Text(
                '예',
                style: AppTextStyles.smallMedium(
                  context,
                  color: AppColors.blackBlack5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomRadioButton({
    required double width,
    required double height,
    required Color color,
    required Color borderColor,
    required bool isSelected,
    required VoidCallback onChanged,
  }) {
    return GestureDetector(
      onTap: onChanged,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: 48.w,
        height: 48.w,
        child: Center(
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(width / 2),
              border: Border.all(color: borderColor, width: 1.0),
            ),
          ),
        ),
      ),
    );
  }
}
