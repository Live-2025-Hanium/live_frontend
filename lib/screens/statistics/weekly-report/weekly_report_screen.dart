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
  final int selectedIndex;

  const WeeklyReportScreen({
    super.key,
    required this.referenceDate,
    required this.missionType,
    required this.selectedIndex,
  });

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  late Jiffy _anchor;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _anchor = widget.referenceDate.startOf(Unit.week);
    _selectedIndex = widget.selectedIndex;
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
                missionType: widget.missionType,
                currentAnchor: _anchor.format(pattern: 'yyyy-MM-dd'),
                selectedIndex: _selectedIndex,
              ),
              WeekNavigator(
                currentAnchor: _anchor,
                onChanged: (start) {
                  setState(() {
                    _anchor = start;
                    _selectedIndex = 0;
                  });
                },
              ),
              Expanded(
                child: MissionList(
                  referenceDate: _anchor.add(days: _selectedIndex),
                  type: widget.missionType,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
