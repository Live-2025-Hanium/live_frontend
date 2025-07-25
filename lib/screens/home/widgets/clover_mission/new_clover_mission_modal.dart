import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission/clover_sub_content.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/models/clover_mission_model.dart';

class NewCloverMissionModal extends StatelessWidget {
  final List<CloverMissionModel> missionList;
  final bool isAdditional;

  const NewCloverMissionModal({
    super.key,
    required this.missionList,
    this.isAdditional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 36.h, 16.w, 4.h),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  isAdditional ? '추가 클로버 미션' : '클로버 미션 도착!',
                  style: AppTextStyles.titleMedium(
                    context,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gap(12.h),
                Image.asset(
                  // 이유는 모르겠는데 svg가 안됨.
                  'assets/images/clover.png',
                  width: 52.w,
                  height: 52.w,
                ),
                Gap(24.h),
                ...missionList.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final data = entry.value;
                  return Column(
                    children: [
                      _buildTitle(
                        context,
                        idx,
                        data.missionTitle,
                        data.missionDifficulty,
                        data.missionCategory,
                      ),
                      Gap(8.h),
                    ],
                  );
                }),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: Icon(Icons.close, color: AppColors.blackBlack4),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    int index,
    String title,
    CloverMissionDifficulty difficulty,
    CloverMissionCategory category,
  ) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
        border: Border.all(color: AppColors.blackBlack1, width: 1.0),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 22.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${index + 1}',
              style: AppTextStyles.titleMedium(
                context,
                color: AppColors.blackBlack4,
              ),
            ),
            Gap(24.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyRegular(
                    context,
                    color: Colors.black,
                  ),
                ),
                Gap(4.h),
                CloverSubContent(difficulty: difficulty, category: category),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
