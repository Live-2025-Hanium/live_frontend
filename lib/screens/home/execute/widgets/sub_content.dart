import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/screens/home/execute/widgets/countdown_timer.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class SubContent extends StatelessWidget {
  final CloverMissionType cloverType;
  final Duration? remainingTime;
  final String? targetAddress;
  final int? remainingDistance;

  const SubContent({
    super.key,
    required this.cloverType,
    this.remainingTime,
    this.targetAddress,
    this.remainingDistance,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '앞으로 남은 시간',
          style: AppTextStyles.bodyRegular(context, color: Colors.black),
        ),
        Gap(16.h),
        if (cloverType == CloverMissionType.timer)
          CountdownTimer(remainingTime: remainingTime ?? Duration.zero),
        Gap(24.h),
        Text(
          '클로버가 눈 앞에! 조금씩 나아가는 중이에요.',
          style: AppTextStyles.bodyRegular(context, color: Colors.black),
        ),
      ],
    );
  }
}
