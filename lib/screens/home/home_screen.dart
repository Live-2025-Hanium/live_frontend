import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/providers/home_provider.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission_list.dart';
import 'package:live_frontend/screens/home/widgets/home_profile.dart';
import 'package:live_frontend/screens/home/widgets/my_mission_list.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

List<MyMissionModel> myMissionList = [
  MyMissionModel(
    userMissionId: 1,
    missionType: MissionType.my,
    missionTitle: 'My Mission 1',
    missionStatus: MissionStatus.started,
    scheduledTime: '08:00',
    repeatDays: [RepeatDay.monday, RepeatDay.wednesday, RepeatDay.friday],
  ),
  MyMissionModel(
    userMissionId: 2,
    missionType: MissionType.my,
    missionTitle: 'My Mission 2',
    missionStatus: MissionStatus.completed,
    scheduledTime: '10:00',
    repeatDays: [RepeatDay.tuesday, RepeatDay.thursday],
  ),
  MyMissionModel(
    userMissionId: 3,
    missionType: MissionType.my,
    missionTitle: 'My Mission 3',
    missionStatus: MissionStatus.started,
    scheduledTime: '22:00',
    repeatDays: [RepeatDay.saturday, RepeatDay.sunday],
  ),
];

// consumer위젯으로 변경
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cloverMissions = ref.watch(cloverMissionNotifierProvider);
    return Scaffold(
      appBar: SaeipAppBar(title: 'Home', appBarStyle: AppBarStyle.common),
      bottomNavigationBar: SaeipNavigationBar(initialIndex: 0),
      body: cloverMissions.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (cloverMissions) => Container(
          color: AppColors.blackBlack0, // 이게 진짜 색상
          // color: Colors.yellow, // 디버깅용으로 노란색 배경
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                HomeProfile(
                  profileImageSrc: 'https://picsum.photos/84',
                  todayCloverCount: 5,
                  todayFinishedMissionCount: 2,
                ),
                Gap(16.h),
                CloverMissionList(),
                Gap(16.h),
                MyMissionList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
