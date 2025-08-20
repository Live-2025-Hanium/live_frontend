import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class SelectionButton extends StatelessWidget {
  final String title;
  final String? selected;
  final bool include;
  final ValueChanged<bool> onToggle;
  final VoidCallback onPressed;

  const SelectionButton({
    super.key,
    required this.title,
    this.selected,
    required this.include,
    required this.onToggle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8.r);

    return Material(
      color: Colors.transparent, // 그림자/고도 없음
      child: Ink(
        decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
        child: InkWell(
          borderRadius: radius,
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 48.h),
            child: Padding(
              padding: EdgeInsetsGeometry.only(left: 16.w, right: 24.w),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.bodyRegular(
                            context,
                            color: Colors.black,
                          ),
                        ),
                        Gap(16.w),
                        if (selected != null && include)
                          Flexible(
                            child: Text(
                              selected!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyRegular(
                                context,
                                color: AppColors.greenNormal,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // 토글 스위치
                  Switch(
                    value: include,
                    onChanged: onToggle,
                    inactiveTrackColor: AppColors.blackBlack2,
                    inactiveThumbColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
