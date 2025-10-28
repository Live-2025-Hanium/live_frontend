import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class TermInfo extends StatelessWidget {
  final String userName;

  const TermInfo({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "$userName ",
                style: AppTextStyles.titleMedium(
                  context,
                  color: AppColors.greenNormal,
                ),
              ),
              Text(
                "님, 반갑습니다!",
                style: AppTextStyles.titleMedium(context, color: Colors.black),
              ),
            ],
          ),
          Gap(8),
          Text(
            "Saeip 서비스 시작을 위해 \n아래 이용 약관을 확인해주세요.",
            style: AppTextStyles.subtitleMedium(
              context,
              color: AppColors.blackBlack4,
            ),
          ),
        ],
      ),
    );
  }
}
