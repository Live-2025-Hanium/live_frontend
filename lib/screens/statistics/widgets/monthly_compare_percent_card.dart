import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MonthlyComparePercentCard extends StatelessWidget {
  final String title; // 좌상단 제목 (예: "Top 1")
  final CloverMissionCategory category; // 지표명 (예: "건강 챙기기")
  final int maxValue; // 분모
  final int currentValue; // 이번달 값
  final int previousValue; // 지난달 값
  final Jiffy? referenceMonth; // 기준 월(미지정 시 now)

  const MonthlyComparePercentCard({
    super.key,
    required this.title,
    required this.category,
    required this.maxValue,
    required this.currentValue,
    required this.previousValue,
    this.referenceMonth,
  });

  @override
  Widget build(BuildContext context) {
    final ref = referenceMonth ?? Jiffy.now().startOf(Unit.month);
    final prevDate = ref.subtract(months: 1);

    final currRatio = _ratio(currentValue);
    final prevRatio = _ratio(previousValue);

    final deltaText = _deltaPercentText(currentValue, previousValue);
    // final deltaIsMinus = deltaText.startsWith('-');

    final baseTrack = Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium(context, color: Colors.black),
          ),
          Gap(4.h),

          // Metric + Delta
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                category.koreanLabel,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyRegular(context, color: Colors.black),
              ),
              Gap(4.w),
              Text(
                deltaText, // e.g. "+17%"
                style: AppTextStyles.bodyRegular(context, color: Colors.black),
              ),
            ],
          ),

          Gap(8.h),

          // 이번달
          Row(
            children: [
              Expanded(
                child: _PercentBar(
                  percent: currRatio,
                  barHeight: 4.h,
                  progressColor: AppColors.pinkNormal,
                  backgroundColor: baseTrack,
                ),
              ),
              Text(
                '${ref.month}월 / $currentValue개',
                style: AppTextStyles.smallMedium(context, color: Colors.black),
              ),
            ],
          ),

          Gap(4.h),

          // 지난달
          Row(
            children: [
              Expanded(
                child: _PercentBar(
                  percent: prevRatio,
                  barHeight: 4.h,
                  progressColor: AppColors.blackBlack2,
                  backgroundColor: baseTrack,
                ),
              ),
              Text(
                '${prevDate.month}월 / $previousValue개',
                style: AppTextStyles.smallMedium(context, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _ratio(int v) {
    if (maxValue <= 0) return 0;
    final clamped = v.clamp(0, maxValue);
    return clamped / maxValue;
  }

  String _deltaPercentText(int curr, int prev) {
    if (prev <= 0) {
      if (curr <= 0) return '0%';
      return '+100%';
    }
    final pct = ((curr - prev) / prev) * 100.0;
    final rounded = pct.round();
    final sign = pct >= 0 ? '+' : '';
    return '$sign$rounded%';
  }
}

class _PercentBar extends StatelessWidget {
  final double percent; // 0.0 ~ 1.0
  final double barHeight;
  final Color progressColor;
  final Color backgroundColor;

  const _PercentBar({
    required this.percent,
    required this.barHeight,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // width는 LayoutBuilder로 얻어서 LinearPercentIndicator에 전달
    return LayoutBuilder(
      builder: (context, constraints) {
        return LinearPercentIndicator(
          width: constraints.maxWidth,
          padding: EdgeInsets.zero,
          lineHeight: barHeight,
          percent: math.max(0.0, math.min(1.0, percent)),
          progressColor: progressColor,
          backgroundColor: backgroundColor,
          barRadius: Radius.circular(barHeight / 2),
          animation: false,
        );
      },
    );
  }
}
