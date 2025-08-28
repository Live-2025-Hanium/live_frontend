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

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime _currentAnchor = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // map weekday (Mon=1..Sun=7) to index 0..6 assuming week starts on Monday

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
                    child: MissionCompletionGauge(
                      percentage: 80.1,
                      month: _currentAnchor.month,
                    ),
                  ),
                  Gap(20.h),
                  WeeklyBarChart(
                    weeklyData: [5, 10, 15, 20, 25, 30, 35],
                    onBarTapped: (index) {
                      // allow tapping a bar to change the selected day
                      setState(() {
                        // convert index (0..6 with Monday=0) back to a DateTime
                        final monday = _startOfWeek(
                          _currentAnchor,
                          DateTime.monday,
                        );
                        _currentAnchor = monday.add(Duration(days: index));
                      });
                    },
                  ),
                  WeekNavigator(
                    currentDate: _currentAnchor,
                    onChanged: (start, end) {
                      // update anchor to new week's start
                      setState(() {
                        _currentAnchor = start;
                      });
                    },
                  ),
                  MonthlyCompareList(referenceDate: _currentAnchor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _startOfWeek(DateTime d, int weekStart) {
    int diff = (d.weekday - weekStart) % 7;
    if (diff < 0) diff += 7;
    final start = DateTime(
      d.year,
      d.month,
      d.day,
    ).subtract(Duration(days: diff));
    return DateTime(start.year, start.month, start.day);
  }
}
