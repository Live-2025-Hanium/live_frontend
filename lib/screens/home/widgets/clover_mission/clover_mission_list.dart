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

class CloverMissionList extends StatefulWidget {
  final List<CloverMissionModel> missionList;
  const CloverMissionList({super.key, required this.missionList});
  @override
  State<CloverMissionList> createState() => _CloverMissionListState();
}

class _CloverMissionListState extends State<CloverMissionList> {
  bool showNewCloverMission = false;

  @override
  void initState() {
    super.initState();
    showNewCloverMission = isMissionAllCompleted();
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
          ...widget.missionList.map((mission) {
            return Column(
              children: [
                MissionTile(
                  missionStatus: mission.missionStatus,
                  missionTitle: mission.missionTitle,
                  subContent: CloverSubContent(
                    category: mission.missionCategory,
                    difficulty: mission.missionDifficulty,
                  ),
                  onTap: () {
                    if (mission.cloverType == CloverMissionType.timer) {
                      context.pushNamed(
                        'timer_mission',
                        extra: mission.userMissionId,
                      );
                    } else {
                      // 다른 타입의 미션 처리 로직
                    }
                  },
                ),
                Gap(8),
              ],
            );
          }),
        ],
      ),
    );
  }
}
