import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/screens/statistics/weekly-report/widget/mission_list_item.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MissionList extends StatelessWidget {
  final DateTime referenceDate;
  final MissionType type;
  const MissionList({
    super.key,
    required this.referenceDate,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
      color: AppColors.blackBlack0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Jiffy.parseFromDateTime(
              referenceDate,
            ).format(pattern: 'yyyy년 MM월 dd일'),
            style: AppTextStyles.subtitleMedium(context),
            textAlign: TextAlign.left,
          ),
          Gap(16.h),
          MissionListItem(
            type: type,
            missionTitle: 'My Mission',
            completedTime: '09:23',
            onTap: () {
              // Handle tap
            },
          ),
        ],
      ),
    );
  }
}
