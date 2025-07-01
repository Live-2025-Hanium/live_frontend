import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';
import 'package:live_frontend/widgets/saeip_toast.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: 'Home'),
      body: Column(
        children: [
          SizedBox(
            child: SaeipButton.outlined(
              onPressed: () => _dialogBuilder(context),
              text: '모달 띄우기',
            ),
          ),
          SaeipToast(message: '토스트 메시지 테스트'),
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
}
