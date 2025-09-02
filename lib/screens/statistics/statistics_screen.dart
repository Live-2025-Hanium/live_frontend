import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/screens/statistics/widgets/mission_completion_gauge.dart';
import 'package:live_frontend/screens/statistics/widgets/monthly_compare_list.dart';
import 'package:live_frontend/screens/statistics/widgets/week_navigator.dart';
import 'package:live_frontend/screens/statistics/widgets/weekly_bar_chart.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  DateTime _currentAnchor = DateTime.now().subtract(
    Duration(days: DateTime.now().weekday - 1),
  );
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackBlack0,
      appBar: SaeipAppBar(appBarStyle: AppBarStyle.common),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            // 탭바 추가
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: AppColors.blackBlack4,
                labelStyle: AppTextStyles.bodyMedium(context),
                unselectedLabelStyle: AppTextStyles.bodyRegular(context),
                indicatorColor: AppColors.blackBlack4,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: AppColors.blackBlack2,
                tabs: const [
                  Tab(text: '클로버 미션'),
                  Tab(text: '마이 미션'),
                ],
              ),
            ),
            // 탭뷰 추가
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // 클로버 미션 탭 내용 - tabIndex를 0으로 고정
                  _buildStatisticsContent(
                    percentage: 80.1,
                    weeklyData: [5, 10, 15, 20, 25, 30, 35],
                    tabIndex: 0, // 클로버 미션은 0
                  ),
                  // 마이 미션 탭 내용 - tabIndex를 1로 고정
                  _buildStatisticsContent(
                    percentage: 65.5,
                    weeklyData: [3, 8, 12, 18, 22, 28, 32],
                    tabIndex: 1, // 마이 미션은 1
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsContent({
    required double percentage,
    required List<double> weeklyData,
    required int tabIndex, // 0: 클로버 미션, 1: 마이 미션
  }) {
    return ListView(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 36.h),
                child: MissionCompletionGauge(
                  percentage: percentage,
                  month: _currentAnchor.month,
                ),
              ),
              WeeklyBarChart(
                weeklyData: weeklyData,
                onBarTapped: (index) {
                  context.pushNamed(
                    'weekly_report',
                    extra: {
                      'referenceDate': _currentAnchor.add(
                        Duration(days: index),
                      ),
                      'missionType': tabIndex == 0
                          ? MissionType.clover
                          : MissionType.my,
                    },
                  );
                },
              ),
              WeekNavigator(
                currentDate: _currentAnchor,
                onChanged: (start, end) {
                  setState(() {
                    _currentAnchor = start;
                  });
                },
              ),
              if (tabIndex == 0)
                MonthlyCompareList(referenceDate: _currentAnchor),
            ],
          ),
        ),
      ],
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
