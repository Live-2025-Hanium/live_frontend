import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/screens/statistics/widgets/mission_completion_gauge.dart';
import 'package:live_frontend/screens/statistics/widgets/monthly_compare_list.dart';
import 'package:live_frontend/screens/statistics/widgets/week_navigator.dart';
import 'package:live_frontend/screens/statistics/widgets/weekly_bar_chart.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  String _currentAnchor = Jiffy.now()
      .startOf(Unit.week)
      .format(pattern: 'yyyy-MM-dd');
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
    return Container(
      color: AppColors.blackBlack0,
      child: SafeArea(
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
                  // 클로버 미션 탭 내용
                  _buildStatisticsContent(tabIndex: 0),
                  // 마이 미션 탭 내용
                  _buildStatisticsContent(tabIndex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsContent({required int tabIndex}) {
    void onBarTapped(int index) {
      debugPrint('Bar $index tapped');
      final refDate = Jiffy.parse(
        _currentAnchor,
      ).startOf(Unit.week).add(days: index);

      debugPrint(
        'Navigating to date: ${refDate.format(pattern: 'yyyy-MM-dd')}',
      );
      context.pushNamed(
        'weekly_report',
        queryParameters: {
          'referenceDate': refDate.format(pattern: 'yyyy-MM-dd'),
          'missionType':
              tabIndex == 0 ? MissionType.clover.name : MissionType.my.name,
          'selectedIndex': index.toString(),
        },
      );
    }

    return ListView(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 36.h),
                child: MissionCompletionGauge(
                  yearMonth: _currentAnchor.substring(0, 7),
                  missionType:
                      tabIndex == 0 ? MissionType.clover : MissionType.my,
                  month: Jiffy.parse(_currentAnchor).month,
                ),
              ),
              WeeklyBarChart(
                missionType:
                    tabIndex == 0 ? MissionType.clover : MissionType.my,
                currentAnchor: _currentAnchor,
                onBarTapped: onBarTapped,
              ),
              WeekNavigator(
                currentAnchor: Jiffy.parse(_currentAnchor),
                onChanged: (start) {
                  setState(() {
                    _currentAnchor = start
                        .startOf(Unit.week)
                        .format(pattern: 'yyyy-MM-dd');
                  });
                },
              ),
              if (tabIndex == 0)
                MonthlyCompareList(referenceDate: Jiffy.parse(_currentAnchor)),
            ],
          ),
        ),
      ],
    );
  }
}
