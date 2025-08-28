import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/screens/statistics/widgets/mission_completion_gauge.dart';
import 'package:live_frontend/screens/statistics/widgets/monthly_compare_list.dart';
import 'package:live_frontend/screens/statistics/widgets/week_navigator.dart';
import 'package:live_frontend/screens/statistics/widgets/weekly_bar_chart.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBlack0,
      appBar: SaeipAppBar(appBarStyle: AppBarStyle.common),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 1),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 36.w,
                      vertical: 16.h,
                    ),
                    child: MissionCompletionGauge(percentage: 80.1),
                  ),
                  Gap(20.h),
                  WeeklyBarChart(weeklyData: [5, 10, 15, 20, 25, 30, 35]),
                  WeekNavigator(
                    initialDate: DateTime.now(),
                    onChanged: (start, end) {
                      // 주가 변경될 때 처리
                    },
                  ),
                  MonthlyCompareList(currentMonth: DateTime.now().month),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
