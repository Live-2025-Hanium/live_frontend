import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MissionTime extends StatelessWidget {
  final String scheduledTime;

  const MissionTime({super.key, required this.scheduledTime});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.access_time, size: 16, color: AppColors.blackBlack3),
        Gap(4.w),
        Text(
          scheduledTime,
          style: AppTextStyles.bodyRegular(
            context,
            color: AppColors.blackBlack4,
          ),
        ),
      ],
    );
  }
}
