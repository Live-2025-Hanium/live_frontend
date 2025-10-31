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
    void onTap() async {
      // 파일 경로가 null이 아닐 때만 동작
      //  debugPrint("Term onTap called with filePath: $filePath");
      if (filePath == null) return;
      //  debugPrint("Navigating to terms detail: $filePath");
      bool? checked = await context.pushNamed(
        'terms_detail',
        pathParameters: {'file_path': filePath!},
        queryParameters: {'isChecked': isChecked ? 'true' : 'false'},
      );
      if (checked != null) {
        onChanged(checked);
      }
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () => onTap(),
      title: Text(
        title,
        style: AppTextStyles.bodyRegular(
          context,
          color: Colors.black,
          decoration: TextDecoration.underline,
        ),
      ),
      leading: SizedBox(
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
      trailing: IconButton(
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(48, 48),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        icon: const Icon(Icons.expand_more_rounded),
        iconSize: 24,
        color: AppColors.blackBlack3,
        onPressed: () => onTap(),
      ),
    );
  }
}
