import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class SelectionTile extends StatelessWidget {
  final String title;
  final String selected;

  const SelectionTile({super.key, required this.title, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              title,
              style: AppTextStyles.bodyRegular(context, color: Colors.black),
            ),
            Gap(30.w),
            Text(
              selected,
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
