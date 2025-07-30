import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class SubContent extends StatelessWidget {
  final Widget? child;
  final String subtitle;

  const SubContent({super.key, this.child, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: AppTextStyles.bodyRegular(context, color: Colors.black),
        ),
        Gap(16.h),
        if (child != null) child!,
        Gap(24.h),
        Text(
          '클로버가 눈 앞에! 조금씩 나아가는 중이에요.',
          style: AppTextStyles.bodyRegular(context, color: Colors.black),
        ),
      ],
    );
  }
}
