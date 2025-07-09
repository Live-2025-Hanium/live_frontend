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
  int _currentPage = 1;
  final int _totalPages = 5;
  final _questions = loadQuestionsFromAssets();

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _currentPage = 1;
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  void goToNextPage() {
    if (_currentPage < _totalPages) {
      _pageViewController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 0,
          bottom: 40.0,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildUserInfoWidget(),
                  const Gap(16),
                  LinearPercentIndicator(
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
                    percent: _currentPage / _totalPages,
                    progressColor: AppColors.greenNormal,
                  ),
                  FutureBuilder(
                    future: _questions,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '오류가 발생했습니다: ${snapshot.error}',
                            style: AppTextStyles.subtitleMedium(context),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            '설문조사 질문이 없습니다.',
                            style: AppTextStyles.subtitleMedium(context),
                          ),
                        );
                      }

                      final questions = snapshot.data!;
                      return _buildLikertSelector(
                        context: context,
                        question: questions[0].question ?? "",
                        selectedIndex: 0,
                        onChanged: (index) => {},
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: SaeipButton(text: '다음', onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 사용자 님에 대해 알려주세요 위젯
  Widget _buildUserInfoWidget() {
    // 사용자 이름 rivorpod에서 가져오기
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
    List<Color> colors = [
      AppColors.pinkNormal,
      AppColors.pinkNormal,
      AppColors.blackBlack3,
      AppColors.greenNormal,
      AppColors.greenNormal,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(question, style: AppTextStyles.subtitleMedium(context))],
    );
  }
}
