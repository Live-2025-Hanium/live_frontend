import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/screens/statistics/widgets/monthly_compare_percent_card.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MonthlyCompareList extends StatelessWidget {
  final int currentMonth;

  const MonthlyCompareList({super.key, required this.currentMonth});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blackBlack0,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '지난 달보다 이만큼 성장했어요!',
            style: AppTextStyles.subtitleMedium(context),
            textAlign: TextAlign.left,
          ),
          Gap(16.h),
          MonthlyComparePercentCard(
            title: "Top 1",
            category: CloverMissionCategory.health,
            maxValue: 100,
            currentValue: 80,
            previousValue: 70,
          ),
          Gap(16.h),
          MonthlyComparePercentCard(
            title: "Top 2",
            category: CloverMissionCategory.hobby,
            maxValue: 100,
            currentValue: 75,
            previousValue: 70,
          ),
          Gap(16.h),
          MonthlyComparePercentCard(
            title: "Top 3",
            category: CloverMissionCategory.relationship,
            maxValue: 100,
            currentValue: 90,
            previousValue: 80,
          ),
        ],
      ),
    );
  }
}
