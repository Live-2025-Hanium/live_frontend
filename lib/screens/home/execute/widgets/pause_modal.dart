// lib/widgets/pause_modal.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';
import 'package:live_frontend/theme/app_colors.dart';

/// 일시정지/다시시작 모달을 보여주는 재사용 위젯
class PauseModal extends StatelessWidget {
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final int userMissionId;

  const PauseModal({
    super.key,
    this.onConfirm,
    this.onCancel,
    required this.userMissionId,
  });

  @override
  Widget build(BuildContext context) {
    return SaeipModal(
      title: '미션 중단',
      message: '괜찮아요. 다음에 다시 시작할 수 있어요.',
      onCancel: () {
        if (onCancel != null) {
          onCancel!();
        }
        Navigator.pop(context);
      },
      onConfirm: () {
        if (onConfirm != null) {
          onConfirm!();
        }
        // 미션 중단 로직
        // 이전 화면으로 돌아가기
        if (GoRouter.of(context).canPop()) {
          context.pop();
        }
        Navigator.pop(context);
      },

      confirmText: '다음에 하기',
      cancelText: '다시 시작',
      confirmBackgroundColor: AppColors.errorError3,
    );
  }
}
