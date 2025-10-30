import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission/new_clover_mission_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission_list.dart';
import 'package:live_frontend/screens/home/widgets/home_profile.dart';
import 'package:live_frontend/screens/home/widgets/my_mission_list.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasShownModalToday = false;

  @override
  void initState() {
    super.initState();
    _checkModalStatus();
    _checkLocationPermission();
  }

  // 앱 시작 시 gps 허용 되어있는지 확인
  Future<void> _checkLocationPermission() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  // 앱 시작 시 오늘 이미 모달을 봤는지 확인
  Future<void> _checkModalStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getString('lastModalDate');
    final today = Jiffy.now().format(pattern: 'yyyy-MM-dd');

    setState(() {
      _hasShownModalToday = (lastShown == today);
    });
  }

  Future<void> _showOncePerDayModal() async {
    // 이미 오늘 모달을 본 경우 리턴
    if (_hasShownModalToday) return;

    final prefs = await SharedPreferences.getInstance();
    final today = Jiffy.now().format(pattern: 'yyyy-MM-dd');

    // 위젯이 여전히 마운트되어 있는지 확인
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => NewCloverMissionModal(),
    );

    // 다이얼로그 닫힌 후에도 mounted 체크
    if (!mounted) return;

    await prefs.setString('lastModalDate', today);
    setState(() {
      _hasShownModalToday = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 오늘 아직 모달을 보지 않았다면 모달 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOncePerDayModal();
    });

    return Scaffold(
      appBar: SaeipAppBar(title: 'Home', appBarStyle: AppBarStyle.common),
      bottomNavigationBar: SaeipNavigationBar(initialIndex: 0),
      body: Container(
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
      ),
    );
  }
}
