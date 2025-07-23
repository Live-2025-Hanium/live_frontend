import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission_list.dart';
import 'package:live_frontend/screens/home/widgets/home_profile.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: 'Home', appBarStyle: AppBarStyle.common),
      bottomNavigationBar: SaeipNavigationBar(initialIndex: 0),
      body: Container(
        color: AppColors.blackBlack0, // 이게 진짜 색상
        // color: Colors.yellow, // 디버깅용으로 노란색 배경
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeProfile(
                profileImageSrc: 'https://picsum.photos/84',
                todayCloverCount: 5,
                todayFinishedMissionCount: 2,
              ),
              Gap(16),
              CloverMissionList(
                missions: [
                  Mission(
                    title: 'Clover Mission 1',
                    missionStatus: MissionStatus.assigned,
                    missionCategory: MissionCategory.health,
                    missionDifficulty: MissionDifficulty.easy,
                    userMissionId: 1,
                  ),
                  Mission(
                    title: 'Clover Mission 1',
                    missionStatus: MissionStatus.completed,
                    missionCategory: MissionCategory.health,
                    missionDifficulty: MissionDifficulty.easy,
                    userMissionId: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
