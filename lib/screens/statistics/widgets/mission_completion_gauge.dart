import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/providers/statistics_provider.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MissionCompletionGauge extends ConsumerWidget {
  final String yearMonth;
  final MissionType missionType;
  final int? month;

  const MissionCompletionGauge({
    super.key,
    required this.yearMonth,
    required this.missionType,
    this.month,
  });

  String get _currentMonthText {
    final m = month ?? DateTime.now().month;
    return '$m월 미션 완료율';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyRateAsync = ref.watch(
      monthlyCompletionRateProvider(
        StatisticsApiPayload(yearMonth: yearMonth, missionType: missionType),
      ),
    );

    return monthlyRateAsync.when(
      data: (data) {
        final percentage = data?.completionRate ?? 0.0;
        return LayoutBuilder(
          builder: (ctx, c) {
            final w = c.maxWidth.isFinite ? c.maxWidth : 288;
            final h = w / 2;

            return SizedBox(
              width: w.toDouble(),
              height: h,
              child: CustomPaint(
                painter: _SemiGaugePainter(
                  percent: percentage.clamp(0, 100).toDouble(),
                  trackColor: AppColors.blackBlack1,
                  progressColor: AppColors.greenNormal,
                  thickness: 10,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.blackBlack1,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.trending_up,
                            size: 20,
                            color: AppColors.blackBlack2,
                          ),
                        ),
                        Gap(12),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontFamily: 'pretendard',
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          _currentMonthText,
                          style: AppTextStyles.bodyRegular(
                            context,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => SizedBox(
        height: 144,
        width: 144,
        child: Center(
          child: SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class _SemiGaugePainter extends CustomPainter {
  final double percent; // 0~100
  final double thickness;
  final Color trackColor;
  final Color progressColor;

  _SemiGaugePainter({
    required this.percent,
    required this.thickness,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 원의 중심을 위젯의 '아래 중앙'으로 두고, 반원(위쪽)만 그림
    final center = Offset(size.width / 2, size.height - thickness / 2);
    final radius = size.width / 2 - thickness / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final progress = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    // 트랙(반원 전체)
    canvas.drawArc(rect, math.pi, math.pi, false, track);
    // 진행(비율만큼)
    final sweep = math.pi * (percent / 100.0);
    canvas.drawArc(rect, math.pi, sweep, false, progress);
  }

  @override
  bool shouldRepaint(covariant _SemiGaugePainter old) =>
      old.percent != percent ||
      old.thickness != thickness ||
      old.trackColor != trackColor ||
      old.progressColor != progressColor;
}
