import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission/clover_mission_list.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission/new_clover_mission_modal.dart';
import 'package:live_frontend/screens/home/widgets/home_profile.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CloverMissionModel> temporaryData = [
  CloverMissionModel(
    userMissionId: 1,
    title: 'Clover Mission 1',
    missionStatus: MissionStatus.assigned,
    missionDifficulty: CloverMissionDifficulty.easy,
    missionCategory: CloverMissionCategory.health,
  ),
  CloverMissionModel(
    userMissionId: 1,
    title: 'Clover Mission 1',
    missionStatus: MissionStatus.assigned,
    missionDifficulty: CloverMissionDifficulty.easy,
    missionCategory: CloverMissionCategory.health,
  ),
  CloverMissionModel(
    userMissionId: 1,
    title: 'Clover Mission 1',
    missionStatus: MissionStatus.assigned,
    missionDifficulty: CloverMissionDifficulty.easy,
    missionCategory: CloverMissionCategory.health,
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOncePerDayModal();
    });
  }

  // 하루에 한 번만 모달을 보여주기 위한 로직
  Future<void> _showOncePerDayModal() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getString('lastModalDate');
    final today = Jiffy.now().format(pattern: 'yyyy-MM-dd');

    if (lastShown != today) {
      // 1) 다이얼로그 띄우기 전에도 mounted 체크
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) => NewCloverMissionModal(missionList: temporaryData),
      );

      // 2) 다이얼로그 닫힌 후에도 mounted 체크
      if (!mounted) return;

      await prefs.setString('lastModalDate', today);
    }
  }

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
              CloverMissionList(missionList: temporaryData),
              Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}
