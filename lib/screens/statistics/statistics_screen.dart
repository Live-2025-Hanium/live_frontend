import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/screens/statistics/widgets/mission_completion_gauge.dart';
import 'package:live_frontend/screens/statistics/widgets/weekly_bar_chart.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(appBarStyle: AppBarStyle.common),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 1),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: MissionCompletionGauge(percentage: 80.1),
              ),
              Gap(36.h),
              WeeklyBarChart(weeklyData: [5, 10, 15, 20, 25, 30, 35]),
            ],
          ),
        ),
      ),
    );
  }
}
