import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';
import 'package:live_frontend/theme/app_colors.dart';

class SaeipModalController {
  static bool _isShowing = false;

  // 텍스트 모달
  static Future<bool?> showText({
    required BuildContext context,
    String? title,
    required String message,
    String? confirmText, 
    Color? confirmBackgroundColor,
    VoidCallback? onConfirm,
    String? cancelText, // null이면 버튼 1개
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return _showModal(
      context: context,
      modal: SaeipModal(
        title: title,
        message: message,
        confirmText: confirmText ?? '확인',
        confirmBackgroundColor: confirmBackgroundColor ?? AppColors.greenDark,
        onConfirm: () {
          onConfirm?.call();
          Navigator.of(context).pop(true);
        },
        onCancel:
            cancelText != null
                ? () {
                  onCancel?.call();
                  Navigator.of(context).pop(false);
                }
                : null,
        cancelMessage: cancelText,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // 이미지 모달
  static Future<bool?> showImage({
    required BuildContext context,
    String? title,
    required String message,
    required Widget image,
    String? confirmText,
    Color? confirmBackgroundColor,
    VoidCallback? onConfirm,
    String? cancelText,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return _showModal(
      context: context,
      modal: SaeipModal.image(
        title: title,
        message: message,
        image: image,
        confirmText: confirmText ?? '확인',
        confirmBackgroundColor: confirmBackgroundColor ?? AppColors.greenDark,
        onConfirm: () {
          onConfirm?.call();
          Navigator.of(context).pop(true);
        },
        onCancel:
            cancelText != null
                ? () {
                  onCancel?.call();
                  Navigator.of(context).pop(false);
                }
                : null,
        cancelMessage: cancelText,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  // 공통 showDialog 호출
  static Future<bool?> _showModal({
    required BuildContext context,
    required Widget modal,
    bool barrierDismissible = true,
  }) async {
    if (_isShowing) return null;
    _isShowing = true;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => modal,
    );

    _isShowing = false;
    return result;
  }
}
