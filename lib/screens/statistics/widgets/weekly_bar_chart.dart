import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class WeeklyBarChart extends StatefulWidget {
  final List<double> weeklyData;
  final Function(int dayIndex)? onBarTapped;

  const WeeklyBarChart({super.key, required this.weeklyData, this.onBarTapped});

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      padding: EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          maxY: widget.weeklyData.reduce((a, b) => a > b ? a : b) + 5,
          minY: 0,
          gridData: FlGridData(
            show: true,
            horizontalInterval: 5,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: AppColors.blackBlack1, strokeWidth: 1);
            },
            getDrawingVerticalLine: (value) {
              return FlLine(color: Colors.transparent);
            },
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                  return Container();
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
                  return Container();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: widget.weeklyData.asMap().entries.map((entry) {
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
                  width: 24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          barTouchData: BarTouchData(
            enabled: true,
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              if (event is FlTapUpEvent && barTouchResponse?.spot != null) {
                final index = barTouchResponse!.spot!.touchedBarGroupIndex;
                setState(() {
                  selectedIndex = selectedIndex == index ? null : index;
                });
                widget.onBarTapped?.call(index);
              }
            },
          ),
        ),
      ),
    );
  }
}
