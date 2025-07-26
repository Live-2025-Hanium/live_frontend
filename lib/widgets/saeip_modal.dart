import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_button.dart';

// 이미지 모달이랑 텍스트 모달 타입

class SaeipModalType {
  static const image = 'image';
  static const text = 'text';
}

class SaeipModal extends StatelessWidget {
  final String? title;
  final String message;
  final String? cancelMessage;
  final void Function()? onCancel;
  final void Function() onConfirm;
  final String confirmText;
  final void Function()? onClose;
  final Color confirmBackgroundColor;
  final String type;
  final Widget? image;

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
    this.type = SaeipModalType.text,
    this.image,
  });

  const SaeipModal.image({
    super.key,
    required this.message,
    this.cancelMessage = '취소',
    required this.onConfirm,
    this.title,
    this.onCancel,
    this.confirmText = '확인',
    this.onClose,
    this.confirmBackgroundColor = AppColors.greenDark,
    required this.image,
  }) : type = SaeipModalType.image;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.fromLTRB(16, 36, 16, 12),
        width: double.infinity,
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
            if (type == SaeipModalType.image)
              Padding(padding: const EdgeInsets.only(top: 12), child: image!),
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
