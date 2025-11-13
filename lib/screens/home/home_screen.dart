import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
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
  Future<void> _showOncePerDayModal() async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getString('lastModalDate');
    final today = Jiffy.now().format(pattern: 'yyyy-MM-dd');

    if (lastShown == today) return;

    // Ensure the widget is still mounted before showing the dialog
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => NewCloverMissionModal(),
    );

    if (!mounted) return;

    ref.invalidate(cloverMissionProvider);

    await prefs.setString('lastModalDate', today);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the cloverMissionProvider to show the modal once data is loaded.
    ref.listen(cloverMissionProvider(null), (previous, next) {
      if (next is AsyncData) {
        _showOncePerDayModal();
      }
    });

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
            const Gap(16),
            CloverMissionList(),
            const Gap(16),
            MyMissionList(),
          ],
        ),
      ),
    );
  }
}
