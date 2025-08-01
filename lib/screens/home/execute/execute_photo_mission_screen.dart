import 'package:flutter/material.dart';
import 'package:live_frontend/screens/home/execute/widgets/execute_screen_template.dart';
import 'package:live_frontend/screens/home/execute/widgets/pause_modal.dart';

class ExecutePhotoMissionScreen extends StatelessWidget {
  const ExecutePhotoMissionScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    return ExecuteScreenTemplate(
      imagePath: 'assets/images/clover_mission/photo.png',
      onLeftPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return PauseModal(userMissionId: id);
          },
        );
      },
      rightLabel: '인증샷 촬영',
      onRightPressed: () {
        // 카메라 로직
      },
      missionTitle: '사진 미션',
    );
  }
}
