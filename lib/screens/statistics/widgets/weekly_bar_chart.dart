import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<double> weeklyData;

  final int? selectedIndex;
  final void Function(int dayIndex)? onBarTapped;

  const WeeklyBarChart({
    super.key,
    required this.weeklyData,
    this.selectedIndex,
    this.onBarTapped,
  });

  @override
  Widget build(BuildContext context) {
    final maxVal =
        (weeklyData.isEmpty
            ? 0.0
            : weeklyData.reduce((a, b) => a > b ? a : b)) +
        5;

    return Container(
      height: 190.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: BarChart(
        BarChartData(
          maxY: maxVal,
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
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
          barGroups: weeklyData.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
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
                // 1) 외부 콜백
                onBarTapped?.call(index);
                // 2) 라우팅 (GoRouter)
                context.pushNamed('home');
              }
            },
          ),
        ),
      ),
    );
  }
}
