import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_button.dart';

class SaeipModal extends StatelessWidget {
  final String? title;
  final String message;
  final void Function()? onCancel;
  final void Function() onConfirm;
  final String confirmText;
  final void Function()? onClose;
  final Color confirmBackgroundColor;

  const SaeipModal({
    super.key,
    this.title,
    required this.message,
    this.onCancel,
    required this.onConfirm,
    required this.confirmText,
    this.onClose,
    this.confirmBackgroundColor = AppColors.greenDark,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 12),
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Text(
                title!,
                style: AppTextStyles.titleSemibold(
                  context,
                  color: AppColors.blackBlack6,
                ),
                textAlign: TextAlign.center,
              ),
            const Gap(4),
            Text(
              message,
              style: AppTextStyles.bodyRegular(context, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const Gap(36),
            Row(
              children: [
                if (onCancel != null) ...[
                  _buildModalButton(
                    context,
                    text: "취소",
                    onPressed: onCancel!,
                    backgroundColor: AppColors.blackBlack1,
                    textColor: Colors.black,
                  ),
                  const Gap(8),
                ],
                _buildModalButton(
                  context,
                  text: confirmText,
                  onPressed: () {
                    onConfirm();
                    if (onClose != null) {
                      onClose!();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModalButton(
    BuildContext context, {
    required String text,
    required void Function() onPressed,
    Color backgroundColor = AppColors.greenDark,
    Color textColor = Colors.white,
  }) {
    return SaeipButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      textStyle: AppTextStyles.bodySemibold(context, color: textColor),
      height: 40,
    );
  }
}
