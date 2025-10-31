import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/screens/mypage/widget/my_mission_list.dart';
import 'package:live_frontend/screens/mypage/widget/profile_widget.dart';
import 'package:live_frontend/theme/app_colors.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.greenDark,
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(16.0), child: ProfileWidget()),
          MyMissionList(),
        ],
      ),
    );
  }
}
