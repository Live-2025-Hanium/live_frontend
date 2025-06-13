import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class Term extends StatelessWidget {
  final String title;
  final String description;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final String? filePath;

  const Term({
    super.key,
    required this.title,
    required this.description,
    required this.isChecked,
    required this.onChanged,
    this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      enabled: filePath != null,
      onTap:
          filePath != null
              ? () {
                context.pushNamed(
                  'terms_detail',
                  pathParameters: {'file_path': filePath!},
                );
              }
              : null,
      title: Text(
        title,
        style: AppTextStyles.bodyRegular(
          context,
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),
      ),
      trailing: SizedBox(
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
    );
  }
}
