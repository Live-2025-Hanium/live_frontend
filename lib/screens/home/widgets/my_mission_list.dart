import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/screens/home/widgets/mission_tile.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';

class MyMissionList extends StatefulWidget {
  final List<MyMissionModel> missionList;
  const MyMissionList({super.key, required this.missionList});
  @override
  State<MyMissionList> createState() => _MyMissionListState();
}

class _MyMissionListState extends State<MyMissionList> {
  late List<MyMissionModel> _sortedMissions;

  @override
  void initState() {
    super.initState();
    _rebuildSorted();
  }

  @override
  void didUpdateWidget(covariant MyMissionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 외부에서 missionList가 바뀌면 다시 정렬
    if (oldWidget.missionList != widget.missionList) {
      _rebuildSorted();
    }
  }

  void _rebuildSorted() {
    _sortedMissions = List<MyMissionModel>.of(widget.missionList)
      ..sort(_missionComparator);
  }

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MY',
            style: AppTextStyles.titleMedium(context, color: Colors.black),
          ),
          Gap(8),

          ..._sortedMissions.map((mission) {
            return Column(
              children: [
                MissionTile(
                  missionStatus: mission.missionStatus,
                  subContent: Text(mission.scheduledTime.join(' ~ ')),
                  missionTitle: mission.missionTitle,
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

  void _onTap(BuildContext context, MyMissionModel mission) {
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
          onConfirm: () {},
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
