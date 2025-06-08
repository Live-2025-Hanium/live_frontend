import 'package:flutter/material.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class Term extends StatelessWidget {
  final String title;
  final String description;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const Term({
    Key? key,
    required this.title,
    required this.description,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: AppTextStyles.subtitleMedium(
            context,
            color: AppColors.blackBlack3,
            decoration: TextDecoration.underline,
          ),
        ),
        SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Transform.scale(
              scale: 24 / 18, // 시각적으로 24x24로 키움
              child: Checkbox(
                value: isChecked,
                onChanged: onChanged,
                activeColor: AppColors.greenNormal,
                checkColor: Colors.white,
                shape: const CircleBorder(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // ✅ 필수
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
