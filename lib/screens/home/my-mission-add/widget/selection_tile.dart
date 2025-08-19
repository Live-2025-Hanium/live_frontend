import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class SelectionTile extends StatelessWidget {
  final String title;
  final String? selected;
  final bool include;
  final ValueChanged<bool> onToggle;

  const SelectionTile({
    super.key,
    required this.title,
    this.selected,
    required this.include,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ExpansionTile(
        trailing: Switch(
          value: include,
          onChanged: onToggle,
          inactiveTrackColor: AppColors.blackBlack2,
          // inactiveTrackColor: Colors.transparent, // 검정색 테두리 제거
          inactiveThumbColor: Colors.white,
        ),
        title: Row(
          children: [
            Text(
              title,
              style: AppTextStyles.bodyRegular(context, color: Colors.black),
            ),
            Gap(30.w),
            if (selected != null)
              Text(
                selected!,
                style: AppTextStyles.bodyRegular(
                  context,
                  color: AppColors.greenNormal,
                ),
              ),
          ],
        ),
        minTileHeight: 48.h,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        children: <Widget>[ListTile(title: Text('This is tile number 1'))],
      ),
    );
  }
}
