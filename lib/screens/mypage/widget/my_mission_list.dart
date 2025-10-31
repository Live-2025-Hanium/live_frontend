import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/core/controllers/my_mission_controller.dart';
import 'package:live_frontend/core/repositories/my_mission_repository.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/providers/my_mission_provider.dart';
import 'package:live_frontend/screens/home/widgets/my_mission/mission_repeat.dart';
import 'package:live_frontend/screens/home/widgets/my_mission/mission_time.dart';
import 'package:live_frontend/screens/mypage/widget/mission_tile.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';

final myMissionControllerProvider = Provider<MyMissionController>((ref) {
  final repository = ref.watch(myMissionRepositoryProvider);
  return MyMissionController(repository);
});

final myMissionsProvider = FutureProvider.autoDispose<List<MyMissionModel>>((
  ref,
) {
  final controller = ref.watch(myMissionControllerProvider);
  return controller.fetchMyMissions();
});

class MyMissionList extends ConsumerWidget {
  const MyMissionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myMissionsAsyncValue = ref.watch(allMyMissionsProvider);

    return myMissionsAsyncValue.when(
      // 로딩 상태 UI
      loading: () => const Center(child: CircularProgressIndicator()),
      // 에러 상태 UI
      error: (err, stack) => Center(child: Text('Error: $err')),
      // 데이터가 성공적으로 로드된 상태 UI
      data: (missionList) {
        if (missionList == null || missionList.isEmpty) {
          return _buildEmptyState(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...missionList.map((mission) {
                    return Column(
                      children: [
                        MissionTile(
                          active: mission.active,
                          subContent: _buildSubContent(
                            MyMissionModel(
                              userMissionId: mission.myMissionId,
                              missionTitle: mission.missionTitle,
                              myMissionStatus: MissionStatus.assigned,
                            ),
                          ),
                          missionTitle: mission.missionTitle,
                          onTap: () => _onTap(context, ref, mission),
                          onCheckBoxTap: () => _onTap(context, ref, mission),
                        ),
                        Gap(8.h),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // 미션 타일 하단 컨텐츠 빌더
  Widget? _buildSubContent(MyMissionModel mission) {
    if (mission.repeatType != null && mission.scheduledTime != null) {
      return Row(
        children: [
          if (mission.scheduledTime != null)
            MissionTime(scheduledTime: mission.scheduledTime!),
          Gap(12.w),
          if (mission.repeatType != null)
            MissionRepeat(repeatInterval: mission.repeatType!.label),
        ],
      );
    }
    return null;
  }

  // 데이터가 없을 때 UI
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const Center(child: Text('오늘은 미션이 없습니다. 새로 추가해보세요!'))],
      ),
    );
  }

  // 미션 활성화 토글 로직
  Future<void> _onTap(
    BuildContext context,
    WidgetRef ref,
    AllMyMissionsModel mission,
  ) async {
    try {
      // Controller를 통해 미션 활성화 토글 요청
      await ref
          .read(myMissionControllerProvider)
          .toggleMissionStatus(mission.myMissionId, !mission.active);

      // 데이터 새로고침: allMyMissionsProvider를 무효화하여 다시 가져오게 함
      ref.invalidate(allMyMissionsProvider);
    } catch (e) {
      debugPrint("Failed to toggle mission status: $e");
    }
  }
}
