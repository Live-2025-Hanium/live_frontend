import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/providers/statistics_provider.dart';
import 'package:live_frontend/screens/statistics/weekly-report/widget/mission_list_item.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MissionList extends ConsumerWidget {
  final Jiffy referenceDate;
  final MissionType type;
  const MissionList({
    super.key,
    required this.referenceDate,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyCompletedMissionsAsync = ref.watch(
      dailyCompletedMissionsProvider(
        StatisticsApiPayload(
          yearMonth: referenceDate.format(pattern: 'yyyy-MM-dd'),
          missionType: type,
        ),
      ),
    );

    return dailyCompletedMissionsAsync.when(
      data: (data) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
          width: double.infinity,
          color: AppColors.blackBlack0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                referenceDate.format(pattern: 'yyyy년 MM월 dd일'),
                style: AppTextStyles.subtitleMedium(context),
                textAlign: TextAlign.left,
              ),

              if (data == null || data.completedMissions.isEmpty) ...[
                Gap(16.h),
                Text(
                  '완료한 미션이 없습니다.',
                  style: AppTextStyles.bodyMedium(
                    context,
                  ).copyWith(color: AppColors.blackBlack5),
                ),
              ] else
                ...data.completedMissions.map(
                  (mission) => Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: MissionListItem(
                      type: type,
                      missionTitle: mission.missionTitle,
                      completedTime: Jiffy.parse(
                        mission.completedAt,
                      ).format(pattern: 'HH:mm'),
                      onTap: () {
                        // Handle tap
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error')),
    );
  }
}
