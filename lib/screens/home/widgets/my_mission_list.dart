import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/core/controllers/my_mission_controller.dart';
import 'package:live_frontend/core/repositories/my_mission_repository.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/screens/home/widgets/mission_tile.dart';
import 'package:live_frontend/screens/home/widgets/my_mission/mission_repeat.dart';
import 'package:live_frontend/screens/home/widgets/my_mission/mission_time.dart';
import 'package:live_frontend/screens/mypage/widget/my_mission_list.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';

class MyMissionList extends ConsumerWidget {
  const MyMissionList({super.key});

  int _missionComparator(MyMissionModel a, MyMissionModel b) {
    final aRank = a.myMissionStatus.index;
    final bRank = b.myMissionStatus.index;
    if (aRank != bRank) return aRank - bRank;

    final at = a.missionTitle.toLowerCase();
    final bt = b.missionTitle.toLowerCase();
    return at.compareTo(bt);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myMissionsAsyncValue = ref.watch(myMissionsProvider);

    return myMissionsAsyncValue.when(
      // 로딩 상태 UI
      loading: () => const Center(child: CircularProgressIndicator()),
      // 에러 상태 UI
      error: (err, stack) => Center(child: Text('Error: $err')),
      // 데이터가 성공적으로 로드된 상태 UI
      data: (missionList) {
        if (missionList.isEmpty) {
          return _buildEmptyState(context);
        }

        final sortedMissions = List<MyMissionModel>.of(missionList)
          ..sort(_missionComparator);

        return Padding(
          padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Gap(8.h),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h, right: 8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...sortedMissions.map((mission) {
                      return Column(
                        children: [
                          MissionTile(
                            missionStatus: mission.myMissionStatus,
                            subContent: _buildSubContent(mission),
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
          ),
        );
      },
    );
  }

  // 헤더 UI 빌더
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'MY',
          style: AppTextStyles.titleMedium(context, color: Colors.black),
        ),
        SizedBox(
          width: math.min(48.w, 56),
          height: math.min(48.w, 56),
          child: IconButton(
            iconSize: math.min(24.w, 28),
            onPressed: () => context.pushNamed('my_mission_add'),
            icon: const Icon(Icons.add),
          ),
        ),
      ],
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
        children: [
          _buildHeader(context),
          Gap(8.h),
          const Center(child: Text('오늘은 미션이 없습니다. 새로 추가해보세요!')),
        ],
      ),
    );
  }

  // 미션 완료 로직
  void _onTap(BuildContext context, WidgetRef ref, MyMissionModel mission) {
    showDialog(
      context: context,
      builder: (context) {
        return SaeipModal(
          title: mission.missionTitle,
          message: '미션을 수행했나요?',
          confirmText: '완료하기',
          cancelText: '닫기',
          onConfirm: () async {
            try {
              // Controller를 통해 미션 완료 요청
              await ref
                  .read(myMissionControllerProvider)
                  .completeMyMission(mission.userMissionId);

              // 데이터 새로고침: myMissionsProvider를 무효화하여 다시 가져오게 함
              ref.invalidate(myMissionsProvider);

              if (context.mounted) Navigator.of(context).pop();
            } catch (e) {
              debugPrint("Failed to complete mission: $e");
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('미션 완료에 실패했습니다.')));
              }
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
