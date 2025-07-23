import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class CloverSubContent extends StatelessWidget {
  final MissionDifficulty difficulty;
  final MissionCategory category;

  const CloverSubContent({
    super.key,
    required this.difficulty,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    const totalStars = 5;
    final emptyStars = totalStars - difficulty.value;
    return Row(
      children: [
        for (var i = 0; i < difficulty.value; i++)
          Icon(Icons.star, size: 16.h, color: Color(0xFFFFC800)),
        // 빈 별
        for (var i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, size: 16.h, color: Color(0xFFFFC800)),
        Gap(8),
        Text(
          category.koreanLabel,
          style: AppTextStyles.bodyRegular(
            context,
            color: AppColors.blackBlack3,
          ),
        ),
      ],
    );
    ;
  }
}
