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
  final int _totalPages = 5;
  final _questions = loadQuestionsFromAssets();

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _currentPage = 0;
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  void goToNextPage() {
    if (_currentPage < _totalPages - 1) {
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
                      /*
						_buildLikertSelector(
                        context: context,
                        question: questions[0].question ?? "",
                        selectedIndex: 0,
                        onChanged: (index) => {},
                      )*/
                      // 데이터가 정상적으로 로드되었을 때
                      final questions = snapshot.data!;
                      return Column(
                        children: [Text("임시로 넣은 텍스트입니다. 실제 질문을 넣어주세요.")],
                        // _buildLikertSelector(
                        //   context: context,
                        //   question: questions[0].question ?? "",
                        //   selectedIndex: 0,
                        //   onChanged: (index) => {},
                        // ),
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
    List<(Color color, Color borderColor)> colors = [
      (AppColors.pinkNormal, AppColors.pinkLightActive),
      (AppColors.pinkNormal, AppColors.pinkLightActive),
      (AppColors.blackBlack3, AppColors.blackBlack2),
      (AppColors.greenNormal, AppColors.greenLightActive),
      (AppColors.greenNormal, AppColors.greenLightActive),
    ];

    List<double> widths = [48.w, 36.w, 28.w, 36.w, 48.w];

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            question,
            style: AppTextStyles.subtitleMedium(context),
            textAlign: TextAlign.start,
          ),
          Gap(15),
          Row(
            children: [
              _buildCustomRadioButton(
                width: widths[0],
                height: widths[0],
                color: colors[0].$1,
                borderColor: colors[0].$2,
                isSelected: selectedIndex == 0,
                onChanged: () => onChanged(0),
              ),
              Gap(24.w),
              _buildCustomRadioButton(
                width: widths[1],
                height: widths[1],
                color: colors[1].$1,
                borderColor: colors[1].$2,
                isSelected: selectedIndex == 1,
                onChanged: () => onChanged(1),
              ),
              Gap(16.w),
              _buildCustomRadioButton(
                width: widths[2],
                height: widths[2],
                color: colors[2].$1,
                borderColor: colors[2].$2,
                isSelected: selectedIndex == 2,
                onChanged: () => onChanged(2),
              ),
              Gap(16.w),
              _buildCustomRadioButton(
                width: widths[3],
                height: widths[3],
                color: colors[3].$1,
                borderColor: colors[3].$2,
                isSelected: selectedIndex == 3,
                onChanged: () => onChanged(3),
              ),
              Gap(24.w),
              _buildCustomRadioButton(
                width: widths[4],
                height: widths[4],
                color: colors[4].$1,
                borderColor: colors[4].$2,
                isSelected: selectedIndex == 4,
                onChanged: () => onChanged(4),
              ),
            ],
          ),

          //   _buildCustomRadioButton(
          //     color: colors[0].$1,
          //     borderColor: colors[0].$2,
          //     width: widths[0],
          //     height: widths[0],
          //     isSelected: selectedIndex == 0,
          //     onChanged: () => onChanged(0),
          //   ),
        ],
      ),
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
      onTap: () {
        onChanged();
      },
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
