import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class MissionCompletionGauge extends StatelessWidget {
  final double percentage;

  const MissionCompletionGauge({super.key, required this.percentage});

  String get _currentMonthText {
    final now = DateTime.now();
    return '${now.month}월 미션 완료율';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 350,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            startAngle: 180,
            endAngle: 360,
            axisLineStyle: AxisLineStyle(
              thickness: 0.1,
              cornerStyle: CornerStyle.bothCurve,
              color: AppColors.blackBlack1,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: percentage,
                width: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
                enableAnimation: true,
                animationDuration: 2000,
                animationType: AnimationType.easeInCirc,
                color: AppColors.greenNormal,
                cornerStyle: CornerStyle.startCurve,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 상단 아이콘
                    Container(
                      width: 32.w,
                      height: 32.w,
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
                    Gap(12.h),
                    // 퍼센트 표시
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontFamily: 'pretendard',
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    // 설명 텍스트
                    Text(
                      _currentMonthText,
                      style: AppTextStyles.bodyRegular(
                        context,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                angle: 270,
                positionFactor: 0.3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
