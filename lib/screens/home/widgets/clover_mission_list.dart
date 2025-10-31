import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/providers/clover_mission_provider.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission/clover_sub_content.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission/new_clover_mission_modal.dart';
import 'package:live_frontend/screens/home/widgets/mission_tile.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';
import 'package:live_frontend/widgets/utils/show_saeip_toast.dart';

class CloverMissionList extends ConsumerStatefulWidget {
  const CloverMissionList({super.key});
  @override
  ConsumerState<CloverMissionList> createState() => _CloverMissionListState();
}

class _CloverMissionListState extends ConsumerState<CloverMissionList> {
  int _missionComparator(CloverMissionModel a, CloverMissionModel b) {
    // Compare by missionStatus, handling nulls (nulls go last)
    final aStatus = a.missionStatus;
    final bStatus = b.missionStatus;

    if (aStatus != bStatus) {
      if (aStatus == null) return 1; // a is null, comes after b
      if (bStatus == null) return -1; // b is null, comes after a
      final aRank = aStatus.index;
      final bRank = bStatus.index;
      if (aRank != bRank) return aRank - bRank;
    }

    // If statuses are the same (or both null), compare by title
    return (a.missionTitle ?? '').toLowerCase().compareTo(
      (b.missionTitle ?? '').toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final missionListAsync = ref.watch(cloverMissionProvider(null));
    return missionListAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('에러가 발생했습니다.')),
      data: (missionList) {
        bool showNewCloverMission = false;
        if (missionList == null || missionList.isEmpty) {
          showNewCloverMission = true;
        } else {
          showNewCloverMission = missionList.every(
            (mission) => mission.missionStatus == MissionStatus.completed,
          );
        }
        final sortedMissions = List<CloverMissionModel>.of(missionList ?? [])
          ..sort(_missionComparator);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clover',
                style: AppTextStyles.titleMedium(context, color: Colors.black),
              ),
              Gap(8),
              if (showNewCloverMission)
                ElevatedButton(
                  onPressed: () => {addCloverMission(context)},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(color: AppColors.greenDark, width: 1),
                    ),
                    backgroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 80),
                  ),
                  child: Text(
                    '+ 새로운 클로버 미션',
                    style: AppTextStyles.bodyRegular(
                      context,
                      color: Colors.black,
                    ),
                  ),
                ),
              Gap(8),
              ...sortedMissions.map((mission) {
                return Column(
                  children: [
                    MissionTile(
                      missionStatus: mission.missionStatus,
                      missionTitle: mission.missionTitle,
                      subContent: CloverSubContent(
                        category: mission.missionCategory,
                        difficulty: mission.missionDifficulty,
                      ),
                      onTap: () => onTap(context, mission),
                      onCheckBoxTap: () => onTap(context, mission),
                    ),
                    Gap(8),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void onTap(BuildContext context, CloverMissionModel mission) {
    showDialog(
      context: context,
      builder: (context) {
        return SaeipModal.image(
          title: mission.missionTitle,
          titleTextColor: AppColors.greenNormal,
          message: '클로버 미션을 수행할까요?',
          image: Image.asset('assets/images/clover.png', width: 80, height: 80),
          confirmText: '시작',
          cancelText: '닫기',
          onConfirm: () async {
            Navigator.of(context).pop();
            await startMission(mission);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> startMission(CloverMissionModel mission) async {
    try {
      await ref.read(
        cloverMissionStateUpdateProvider({
          'status': MissionStatus.started,
          'missionId': mission.userMissionId,
        }).future,
      );

      if (!mounted) return;

      debugPrint('클로버 미션 시작 성공: ${mission.missionTitle}');
      if (mission.cloverType == CloverMissionType.timer) {
        context.pushNamed(
          'timer_mission',
          pathParameters: {'id': mission.userMissionId.toString()},
        );
      } else if (mission.cloverType == CloverMissionType.photo) {
        context.pushNamed(
          'photo_mission',
          pathParameters: {'id': mission.userMissionId.toString()},
        );
      } else if (mission.cloverType == CloverMissionType.visit) {
        debugPrint('Visiting mission navigation');
        context.pushNamed(
          'visit_mission',
          pathParameters: {'id': mission.userMissionId.toString()},
        );
      }
    } catch (error, stack) {
      if (!mounted) return;
      SaeipToastController.showMessage(context, '미션 시작에 실패했습니다. 다시 시도해주세요.');
    }
  }

  void addCloverMission(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return NewCloverMissionModal(isAdditional: true);
      },
    );
  }
}
