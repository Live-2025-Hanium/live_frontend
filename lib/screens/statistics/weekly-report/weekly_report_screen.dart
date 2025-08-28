import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: '마이 미션 주간 레포트'),
      body: SafeArea(
        child: Container(padding: const EdgeInsets.all(16.0), child: Column()),
      ),
    );
  }
}
