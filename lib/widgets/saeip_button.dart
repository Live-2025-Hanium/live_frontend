import 'package:flutter/material.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class SaeipButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final TextStyle? textStyle;

  const SaeipButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.greenDark,
    this.textColor = Colors.white,
    this.height = 48,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: backgroundColor,
          minimumSize: Size(height, height),
        ),
        child: Text(
          text,
          style:
              textStyle ??
              AppTextStyles.bodySemibold(context, color: textColor),
        ),
      ),
    );
  }
}
