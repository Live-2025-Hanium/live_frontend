import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MissionRepeat extends StatelessWidget {
  final String repeatInterval;

  const MissionRepeat({super.key, required this.repeatInterval});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.repeat_rounded, size: 16, color: AppColors.blackBlack3),
        Gap(4),
        Text(
          repeatInterval,
          style: AppTextStyles.bodyRegular(
            context,
            color: AppColors.blackBlack4,
          ),
        ),
      ],
    );
  }
}
