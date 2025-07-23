import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class NewCloverMissionModal extends StatelessWidget {
  const NewCloverMissionModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.white,
          border: Border.all(color: AppColors.blackBlack1, width: 1.0),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 22.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '1',
                style: AppTextStyles.titleMedium(
                  context,
                  color: AppColors.blackBlack4,
                ),
              ),
              Gap(24.w),
              Column(
                children: [
                  Text(
                    'Total Views',
                    style: AppTextStyles.bodyRegular(
                      context,
                      color: AppColors.blackBlack4,
                    ),
                  ),
                  Text(
                    '1,234',
                    style: AppTextStyles.bodyRegular(
                      context,
                      color: AppColors.blackBlack4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
