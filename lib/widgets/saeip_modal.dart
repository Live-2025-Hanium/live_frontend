import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_button.dart';

class SaeipModal extends StatelessWidget {
  final String? title;
  final String message;
  final String? cancelMessage;
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
    this.cancelMessage = '취소',
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
                  Expanded(
                    child: SaeipButton(
                      text: cancelMessage!,
                      onPressed: onCancel!,
                      backgroundColor: AppColors.blackBlack1,
                      textStyle: AppTextStyles.bodyRegular(
                        context,
                        color: Colors.black,
                      ),
                      height: 40,
                    ),
                  ),
                  const Gap(8),
                ],
                Expanded(
                  child: SaeipButton(
                    text: confirmText,
                    onPressed: () {
                      onConfirm();
                      if (onClose != null) {
                        onClose!();
                        Navigator.of(context).pop();
                      }
                    },
                    textStyle: AppTextStyles.bodyMedium(
                      context,
                      color: Colors.white,
                    ),
                    height: 40,
                    backgroundColor: confirmBackgroundColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
