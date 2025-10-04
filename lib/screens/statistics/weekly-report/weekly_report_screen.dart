import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/screens/statistics/weekly-report/widget/mission_list.dart';
import 'package:live_frontend/screens/statistics/widgets/week_navigator.dart';
import 'package:live_frontend/screens/statistics/widgets/weekly_bar_chart.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';

class WeeklyReportScreen extends StatefulWidget {
  final Jiffy referenceDate;
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
  late Jiffy _anchor; // Monday of the reference week
  late int _selectedIndex; // 0..6 where 0 = Monday

  @override
  void initState() {
    super.initState();
    _anchor = widget.referenceDate.startOf(Unit.week);
    _selectedIndex = (widget.referenceDate.date - DateTime.monday) % 7;
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
                currentAnchor: _anchor,
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
}
