import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/providers/home_provider.dart';
import 'package:live_frontend/screens/home/widgets/mission_tile.dart';
import 'package:live_frontend/screens/home/widgets/my_mission/mission_repeat.dart';
import 'package:live_frontend/screens/home/widgets/my_mission/mission_time.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';

class MyMissionList extends ConsumerStatefulWidget {
  const MyMissionList({super.key});
  @override
  ConsumerState<MyMissionList> createState() => _MyMissionListState();
}

class _MyMissionListState extends ConsumerState<MyMissionList> {
  int _missionComparator(MyMissionModel a, MyMissionModel b) {
    // null 안전: status가 null이면 가장 뒤로 밀기
    final aRank = a.missionStatus.index;
    final bRank = b.missionStatus.index;
    if (aRank != bRank) return aRank - bRank;

    // null/대소문자 안전한 제목 비교
    final at = a.missionTitle.toLowerCase();
    final bt = b.missionTitle.toLowerCase();
    return at.compareTo(bt);
  }

  @override
  Widget build(BuildContext context) {
    final missionListAsync = ref.watch(myMissionNotifierProvider);
    return missionListAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
      data: (missionList) {
        final sortedMissions = List<MyMissionModel>.of(missionList)
          ..sort(_missionComparator);
        return Padding(
          padding: EdgeInsets.only(top: 8.h, left: 16.w, right: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'MY',
                    style: AppTextStyles.titleMedium(
                      context,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: IconButton(
                      iconSize: 24.w,
                      onPressed: () {
                        context.pushNamed('my_mission_add');
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
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
                            missionStatus: mission.missionStatus,
                            subContent: Row(
                              children: [
                                MissionTime(
                                  scheduledTime: mission.scheduledTime,
                                ),
                                Gap(12.w),
                                MissionRepeat(
                                  repeatInterval: mission.repeatDays
                                      .map((e) => e.label)
                                      .join(', '),
                                ),
                              ],
                            ),
                            missionTitle: mission.missionTitle,
                            onTap: () => _onTap(context, mission),
                            onCheckBoxTap: () => _onTap(context, mission),
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

  void _onTap(BuildContext context, MyMissionModel mission) {
    showDialog(
      context: context,
      builder: (context) {
        return SaeipModal(
          title: mission.missionTitle,
          message: '미션을 수행했나요?',
          confirmText: '완료하기',
          cancelText: '닫기',
          onConfirm: () {
            // 미션 완료 처리
            // 모달 닫기
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
