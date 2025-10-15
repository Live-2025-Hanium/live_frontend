import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/providers/statistics_provider.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class WeeklyBarChart extends ConsumerWidget {
  final int? selectedIndex;
  final MissionType missionType;
  final String currentAnchor;

  const WeeklyBarChart({
    super.key,
    this.selectedIndex,
    required this.missionType,
    required this.currentAnchor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onBarTapped(int index) {
      final refDate = Jiffy.parse(
        currentAnchor,
      ).startOf(Unit.week).add(days: index);
      context.pushNamed(
        'weekly_report',
        queryParameters: {
          'referenceDate': refDate.format(pattern: 'yyyy-MM-dd'),
          'missionType': missionType.name,
        },
      );
    }

    final weeklyMissionSummaryAsync = ref.watch(
      weeklyCompletionRatesProvider(
        StatisticsApiPayload(
          yearMonth: currentAnchor,
          missionType: missionType,
        ),
      ),
    );

    return weeklyMissionSummaryAsync.when(
      data: (data) {
        final maxVal =
            (data?.weeklySummary
                    .map((e) => e.missionCount)
                    .reduce((a, b) => a > b ? a : b) ??
                10) +
            5;
        return Container(
          height: 190.h,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: BarChart(
            BarChartData(
              maxY: maxVal.toDouble(),
              minY: 0,
              gridData: FlGridData(
                show: true,
                horizontalInterval: 5,
                verticalInterval: 1,
                getDrawingHorizontalLine: (value) =>
                    FlLine(color: AppColors.blackBlack1, strokeWidth: 1),
                getDrawingVerticalLine: (value) =>
                    const FlLine(color: Colors.transparent),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value % 5 == 0) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      const days = ['월', '화', '수', '목', '금', '토', '일'];
                      if (value.toInt() < days.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            days[value.toInt()],
                            style: AppTextStyles.smallMedium(
                              context,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: data!.weeklySummary.asMap().entries.map((entry) {
                final index = entry.key;
                final value = entry.value.missionCount.toDouble();
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: value,
                      color: selectedIndex == index
                          ? AppColors.greenNormal
                          : AppColors.greenLightActive,
                      width: 24.w,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                );
              }).toList(),
              barTouchData: BarTouchData(
                enabled: true,
                touchCallback: (event, response) {
                  if (event is FlTapUpEvent && response?.spot != null) {
                    final index = response!.spot!.touchedBarGroupIndex;
                    onBarTapped.call(index);
                  }
                },
              ),
            ),
          ),
        );
      },
      loading: () {
        return SizedBox(
          height: 190.h,
          child: Center(
            child: SizedBox(
              height: 40.w,
              width: 40.w,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return SizedBox(
          height: 190.h,
          child: Center(
            child: Text(
              '데이터를 불러오는 중 오류가 발생했어요.',
              style: AppTextStyles.bodyRegular(context, color: Colors.red),
            ),
          ),
        );
      },
    );
  }
}
