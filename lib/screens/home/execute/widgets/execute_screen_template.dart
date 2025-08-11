import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';

class ExecuteScreenTemplate extends StatelessWidget {
  final String imagePath;
  final Widget? child;
  final String leftLabel;
  final VoidCallback onLeftPressed;
  final String rightLabel;
  final VoidCallback? onRightPressed;
  final String missionTitle;

  const ExecuteScreenTemplate({
    super.key,
    required this.imagePath,
    this.child,
    this.leftLabel = '일시정지',
    required this.onLeftPressed,
    this.rightLabel = '완료',
    required this.onRightPressed,
    required this.missionTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: '미션 수행'),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 40.h),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 상단 컨텐츠
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    missionTitle,
                    style: AppTextStyles.titleMedium(
                      context,
                      color: AppColors.greenNormal,
                    ),
                  ),
                  Gap(4.h),
                  Text('미션을 진행 중이에요.'),
                  Gap(16.h),
                  Align(
                    alignment: Alignment.center,
                    widthFactor: 1.0,
                    child: Image.asset(imagePath, fit: BoxFit.scaleDown),
                  ),
                  Gap(24.h),
                  if (child != null) child!,
                ],
              ),
              // 하단 버튼
              Row(
                children: [
                  Expanded(
                    child: SaeipButton.outlined(
                      text: leftLabel,
                      outlineColor: AppColors.blackBlack2,
                      onPressed: () {
                        onLeftPressed();
                      },
                    ),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: SaeipButton(
                      text: rightLabel,
                      disabled: onRightPressed == null,
                      onPressed: onRightPressed ?? () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
