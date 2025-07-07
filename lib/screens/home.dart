import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';
import 'package:live_frontend/widgets/saeip_toast.dart';
import 'package:live_frontend/widgets/utils/show_saeip_toast.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: 'Home'),
      bottomNavigationBar: SaeipNavigationBar(initialIndex: 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SaeipButton.outlined(
            onPressed: () => _dialogBuilder(context),
            text: '모달 띄우기',
          ),
          SaeipButton(onPressed: () => _showToast(context), text: '토스트 띄우기'),
        ],
      ),
    );
  }

  // 모달 띄우기
  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SaeipModal(
          title: "모달 테스트",
          message: "모달 테스트다!",
          onConfirm: () => Navigator.of(context).pop(),
          confirmText: "확인",
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // 토스트 띄우기
  void _showToast(BuildContext context) {
    showSaeipToast(
      context: context,
      child: SaeipToast(message: '토스트 메시지 테스트'),
      duration: const Duration(seconds: 2),
    );
  }
}
