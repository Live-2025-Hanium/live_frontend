import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_frontend/providers/clover_mission_provider.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission/new_clover_mission_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission_list.dart';
import 'package:live_frontend/screens/home/widgets/home_profile.dart';
import 'package:live_frontend/screens/home/widgets/my_mission_list.dart';
import 'package:live_frontend/theme/app_colors.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  // 앱 시작 시 gps 허용 되어있는지 확인
  Future<void> _checkLocationPermission() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
    _showOncePerDayModal();
  }

  Future<void> _showOncePerDayModal() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getString('lastModalDate');
    final today = Jiffy.now().format(pattern: 'yyyy-MM-dd');

    if (lastShown == today) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) => NewCloverMissionModal(),
      );

      if (!mounted) return;

      ref.invalidate(cloverMissionProvider);

      await prefs.setString('lastModalDate', today);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blackBlack0,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            HomeProfile(
              profileImageSrc: 'https://picsum.photos/84',
              todayCloverCount: 0,
              todayFinishedMissionCount: 0,
            ),
            Gap(16),
            CloverMissionList(),
            Gap(16),
            MyMissionList(),
          ],
        ),
      ),
    );
  }
}
