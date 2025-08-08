import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/screens/home/clover-record/widget/bipolar_range_slider.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/rating_bar.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';

final CloverMissionDetailModel data = CloverMissionDetailModel(
  userMissionId: 100,
  cloverType: CloverMissionType.photo,
  missionTitle: '오늘의 점심 인증샷 찍기',
  description: '오늘 먹은 점심을 사진으로 남겨보세요!',
  missionStatus: MissionStatus.assigned,
  missionDifficulty: CloverMissionDifficulty.normal,
  missionCategory: CloverMissionCategory.hobby,
  illustrationUrl: 'https://example.com/photo_mission.png',
);

// 나중에 extra로 미션 데이터 받아오기!
class MissionRecordScreen extends StatefulWidget {
  const MissionRecordScreen({super.key});

  @override
  State<MissionRecordScreen> createState() => _MissionRecordScreenState();
}

class _MissionRecordScreenState extends State<MissionRecordScreen> {
  final TextEditingController _controller = TextEditingController();
  int _sliderCurrentValue = 3; // 초기값은 중립 상태
  CloverMissionFeedbackModel? _feedback;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSaveTap() {
    _feedback = CloverMissionFeedbackModel(
      userMissionId: data.userMissionId,
      feedbackComment: _controller.text,
      feedbackDifficulty: CloverMissionDifficulty.fromValue(
        _sliderCurrentValue,
      ),
    );
    if (_feedback != null) {
      // 서버에 피드백 저장 로직 추가
      debugPrint(_feedback!.toJson().toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: '미션 기록'),
      body: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 40.h),
        width: double.infinity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: SizedBox(
                      width: 124.w,
                      height: 124.w,
                      child: Image.asset(
                        'assets/images/clover_mission_complete.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48.w,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        '사진 촬영',
                        style: AppTextStyles.smallMedium(
                          context,
                          color: AppColors.blackBlack4,
                        ).copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  Text(
                    data.missionTitle,
                    style: AppTextStyles.titleMedium(
                      context,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RatingBar(rating: data.missionDifficulty.value),
                      Gap(8.w),
                      Text(
                        data.missionCategory.koreanLabel,
                        style: AppTextStyles.bodyRegular(
                          context,
                          color: AppColors.blackBlack4,
                        ),
                      ),
                    ],
                  ),
                  BipolarRangeSlider(
                    key: const Key('bipolar_range_slider'),
                    onChanged: (values) {
                      setState(() {
                        // 슬라이더 값 변경 시 상태 업데이트
                        _sliderCurrentValue = values;
                      });
                    },
                  ),
                  Gap(32.h),
                  TextField(
                    controller: _controller,
                    maxLines: 6,
                    maxLength: 200,
                    style: AppTextStyles.bodyRegular(
                      context,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      counterStyle: AppTextStyles.smallMedium(
                        context,
                        color: AppColors.blackBlack4,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      fillColor: AppColors.blackBlack0,
                      filled: true,
                      hintText: '미션을 완료하고 기분이 어땠나요?',
                      hintStyle: AppTextStyles.bodyRegular(
                        context,
                        color: AppColors.blackBlack4,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: SaeipButton(text: '저장', onPressed: onSaveTap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
