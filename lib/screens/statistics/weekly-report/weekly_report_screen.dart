import 'package:flutter/material.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/screens/statistics/weekly-report/widget/mission_list.dart';
import 'package:live_frontend/screens/statistics/widgets/week_navigator.dart';
import 'package:live_frontend/screens/statistics/widgets/weekly_bar_chart.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';

class WeeklyReportScreen extends StatefulWidget {
  final DateTime referenceDate;
  final MissionType missionType;

  const WeeklyReportScreen({
    super.key,
    required this.referenceDate,
    required this.missionType,
  });

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  late DateTime _anchor; // Monday of the reference week
  late int _selectedIndex; // 0..6 where 0 = Monday

  @override
  void initState() {
    super.initState();
    _anchor = _startOfWeek(widget.referenceDate, DateTime.monday);
    _selectedIndex = (widget.referenceDate.weekday - DateTime.monday) % 7;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(
        title: widget.missionType == MissionType.my
            ? '마이 미션 주간 레포트'
            : '클로버 미션 주간 레포트',
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              WeeklyBarChart(
                weeklyData: [5, 10, 15, 20, 25, 30, 35],
                selectedIndex: _selectedIndex,
                onBarTapped: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
              WeekNavigator(
                currentDate: _anchor,
                onChanged: (start, end) {
                  setState(() {
                    _anchor = start;
                    _selectedIndex = 0; // reset selection to Monday of new week
                  });
                },
              ),
              Expanded(
                child: MissionList(
                  referenceDate: _anchor,
                  type: widget.missionType,
                ),
              ), // Updated here
            ],
          ),
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
