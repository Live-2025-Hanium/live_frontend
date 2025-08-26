import 'package:flutter/material.dart';
import 'package:live_frontend/screens/statistics/widgets/MissionCompletionGauge.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(appBarStyle: AppBarStyle.common),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 1),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [MissionCompletionGauge(percentage: 80.1)],
          ),
        ),
      ),
    );
  }
}
