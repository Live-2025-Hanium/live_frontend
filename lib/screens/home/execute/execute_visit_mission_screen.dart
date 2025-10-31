import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/providers/clover_mission_provider.dart';
import 'package:live_frontend/screens/home/execute/widgets/complete_modal.dart';
import 'package:live_frontend/screens/home/execute/widgets/execute_screen_template.dart';
import 'package:live_frontend/screens/home/execute/widgets/pause_modal.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';

// TODO: 위치 기반 기능 추가 필요
class ExecuteVisitMissionScreen extends ConsumerWidget {
  final int id;
  const ExecuteVisitMissionScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionDetailAsync = ref.watch(cloverMissionDetailProvider(id));

    Future<void> onRightPressed() async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) {
            return CompleteModal(userMissionId: id);
          },
        );
      });
    }

    return missionDetailAsync.when(
      data: (detail) {
        return Scaffold(
          appBar: SaeipAppBar(title: '미션 수행'),
          body: ExecuteScreenTemplate(
            imagePath: 'assets/images/clover_mission/distance.png',
            onLeftPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return PauseModal(userMissionId: id);
                },
              );
            },
            onRightPressed: onRightPressed,
            missionTitle: detail?.missionTitle ?? '방문 미션',
          ),
        );
      },
      error: (error, stack) => Scaffold(body: Center(child: Text('Error'))),
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
