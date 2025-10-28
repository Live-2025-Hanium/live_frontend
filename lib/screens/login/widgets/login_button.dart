import 'package:flutter/material.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Widget icon;
  final Color? backgroundColor;
  final BorderSide borderSide;
  final Color textColor;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    this.backgroundColor,
    this.borderSide = BorderSide.none,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: borderSide,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(alignment: Alignment.centerLeft, child: icon),
            Center(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium(context, color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
