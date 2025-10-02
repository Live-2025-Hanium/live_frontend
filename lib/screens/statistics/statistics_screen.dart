import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/core/controllers/statistics_controller.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/models/statistics_model.dart';
import 'package:live_frontend/screens/statistics/widgets/mission_completion_gauge.dart';
import 'package:live_frontend/screens/statistics/widgets/monthly_compare_list.dart';
import 'package:live_frontend/screens/statistics/widgets/week_navigator.dart';
import 'package:live_frontend/screens/statistics/widgets/weekly_bar_chart.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class MonthlyCompletionRatePayload {
  final String yearMonth;
  final MissionType missionType;

  MonthlyCompletionRatePayload({
    required this.yearMonth,
    required this.missionType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyCompletionRatePayload &&
          runtimeType == other.runtimeType &&
          yearMonth == other.yearMonth &&
          missionType == other.missionType;

  @override
  int get hashCode => yearMonth.hashCode ^ missionType.hashCode;
}

final monthlyCompletionRateProvider =
    FutureProvider.family<
      MonthlyCompletionRateModel?,
      MonthlyCompletionRatePayload
    >((ref, payload) {
      final controller = ref.read(statisticsControllerProvider);
      if (payload.missionType == MissionType.clover) {
        return controller.fetchMonthlyCloverRate(payload.yearMonth);
      } else {
        return controller.fetchMonthlyMyRate(payload.yearMonth);
      }
    });

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
    final cloverRateAsync = ref.watch(
      monthlyCompletionRateProvider(
        MonthlyCompletionRatePayload(
          yearMonth: _currentAnchor.substring(0, 7),
          missionType: MissionType.clover,
        ),
      ),
    );
    final myRateAsync = ref.watch(
      monthlyCompletionRateProvider(
        MonthlyCompletionRatePayload(
          yearMonth: _currentAnchor.substring(0, 7),
          missionType: MissionType.my,
        ),
      ),
    );

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
                  // 클로버 미션 탭 내용
                  cloverRateAsync.when(
                    data: (data) => _buildStatisticsContent(
                      percentage: data?.completionRate ?? 0.0,
                      weeklyData: [
                        5,
                        10,
                        15,
                        20,
                        25,
                        30,
                        35,
                      ], // TODO: Replace with actual data
                      tabIndex: 0,
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
                  ),
                  // 마이 미션 탭 내용
                  myRateAsync.when(
                    data: (data) => _buildStatisticsContent(
                      percentage: data?.completionRate ?? 0.0,
                      weeklyData: [
                        3,
                        8,
                        12,
                        18,
                        22,
                        28,
                        32,
                      ], // TODO: Replace with actual data
                      tabIndex: 1,
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Error: $err')),
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
                  month: Jiffy.parse(_currentAnchor).month,
                ),
              ),
              WeeklyBarChart(
                weeklyData: weeklyData,
                onBarTapped: (index) {
                  final refDate = Jiffy.parse(
                    _currentAnchor,
                  ).startOf(Unit.week).add(days: index);
                  context.pushNamed(
                    'weekly_report',
                    queryParameters: {
                      'referenceDate': refDate.format(pattern: 'yyyy-MM-dd'),
                      'missionType': tabIndex == 0
                          ? MissionType.clover.toString().split('.').last
                          : MissionType.my.toString().split('.').last,
                    },
                  );
                },
              ),
              WeekNavigator(
                currentAnchor: Jiffy.parse(_currentAnchor),
                onChanged: (start, end) {
                  setState(() {
                    _currentAnchor = start
                        .startOf(Unit.week)
                        .format(pattern: 'yyyy-MM-dd');
                  });
                },
              ),
              if (tabIndex == 0)
                MonthlyCompareList(
                  referenceDate: Jiffy.parse(_currentAnchor).dateTime,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
