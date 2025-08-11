import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

enum SaeipButtonType { filled, outlined }

class SaeipButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final TextStyle? textStyle;
  final SaeipButtonType type;
  final bool disabled;
  final Color? outlineColor;

  const SaeipButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.greenDark,
    this.textColor = Colors.white,
    this.height = 48,
    this.textStyle,
    this.type = SaeipButtonType.filled,
    this.disabled = false,
    this.outlineColor,
  });

  const SaeipButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.height = 48,
    this.textStyle,
    this.disabled = false,
    this.outlineColor = AppColors.greenDark,
  }) : type = SaeipButtonType.outlined;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: type == SaeipButtonType.outlined
              ? BorderSide(color: outlineColor ?? AppColors.greenDark, width: 1)
              : BorderSide.none,
        ),
        backgroundColor: backgroundColor,
        minimumSize: Size(height.h, height.h),
      ),
      child: Text(
        text,
        style:
            textStyle ?? AppTextStyles.bodySemibold(context, color: textColor),
      ),
    );
  }
}
