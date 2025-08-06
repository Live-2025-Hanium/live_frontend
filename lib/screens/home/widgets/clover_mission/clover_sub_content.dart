import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/widgets/rating_bar.dart';

class CloverSubContent extends StatelessWidget {
  final CloverMissionDifficulty difficulty;
  final CloverMissionCategory category;

  const CloverSubContent({
    super.key,
    required this.difficulty,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBar(rating: difficulty.value),
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
  }
}
