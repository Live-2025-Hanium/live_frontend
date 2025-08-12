import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission/clover_sub_content.dart';
import 'package:live_frontend/screens/home/widgets/mission_tile.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';

class CloverMissionList extends StatefulWidget {
  final List<CloverMissionModel> missionList;
  const CloverMissionList({super.key, required this.missionList});
  @override
  State<CloverMissionList> createState() => _CloverMissionListState();
}

class _CloverMissionListState extends State<CloverMissionList> {
  bool showNewCloverMission = false;
  late List<CloverMissionModel> _sortedMissions;

  @override
  void initState() {
    super.initState();
    _rebuildSorted();
    showNewCloverMission = isMissionAllCompleted();
  }

  @override
  void didUpdateWidget(covariant CloverMissionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 외부에서 missionList가 바뀌면 다시 정렬
    if (oldWidget.missionList != widget.missionList) {
      _rebuildSorted();
    }
  }

  void _rebuildSorted() {
    _sortedMissions = List<CloverMissionModel>.of(widget.missionList)
      ..sort(_missionComparator);
  }

  int _missionComparator(CloverMissionModel a, CloverMissionModel b) {
    // null 안전: status가 null이면 가장 뒤로 밀기
    final aRank = a.missionStatus.index;
    final bRank = b.missionStatus.index;
    if (aRank != bRank) return aRank - bRank;

    // null/대소문자 안전한 제목 비교
    final at = a.missionTitle.toLowerCase();
    final bt = b.missionTitle.toLowerCase();
    return at.compareTo(bt);
  }

  bool isMissionAllCompleted() {
    return widget.missionList.every(
      (mission) => mission.missionStatus == MissionStatus.completed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
              onPressed: () => {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: AppColors.greenDark, width: 1),
                ),
                backgroundColor: Colors.white,
                minimumSize: Size(double.infinity, 80.w),
              ),
              child: Text(
                '+ 새로운 클로버 미션',
                style: AppTextStyles.bodyRegular(context, color: Colors.black),
              ),
            ),
          Gap(8),
          ..._sortedMissions.map((mission) {
            return Column(
              children: [
                MissionTile(
                  missionStatus: mission.missionStatus,
                  missionTitle: mission.missionTitle,
                  subContent: CloverSubContent(
                    category: mission.missionCategory,
                    difficulty: mission.missionDifficulty,
                  ),
                  onTap: () => _onTap(context, mission),
                  onCheckBoxTap: () => _onTap(context, mission),
                ),
                Gap(8),
              ],
            );
          }),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, CloverMissionModel mission) {
    showDialog(
      context: context,
      builder: (context) {
        return SaeipModal.image(
          title: mission.missionTitle,
          titleTextColor: AppColors.greenNormal,
          message: '클로버 미션을 수행할까요?',
          image: Image.asset(
            'assets/images/clover.png',
            width: 80.w,
            height: 80.w,
          ),
          confirmText: '시작',
          cancelText: '닫기',
          onConfirm: () {
            _startMission(mission);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _startMission(CloverMissionModel mission) {
    if (mission.cloverType == CloverMissionType.timer) {
      context.pushNamed('timer_mission', extra: mission.userMissionId);
    } else if (mission.cloverType == CloverMissionType.photo) {
      context.pushNamed('photo_mission', extra: mission.userMissionId);
      // 다른 타입의 미션 처리 로직
    }
  }
}
