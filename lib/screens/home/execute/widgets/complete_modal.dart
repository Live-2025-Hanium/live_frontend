import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';

class CompleteModal extends StatelessWidget {
  const CompleteModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SaeipModal.image(
      title: '미션 완료',
      message: '오늘의 클로버를 획득했어요.',
      confirmText: '기록하기',
      onConfirm: () {
        context.goNamed('forum'); // 임시 처리 이후 기록 화면 처리로 변경 예정
      },
      cancelText: '닫기',
      onCancel: () {
        context.goNamed('home'); // 임시 처리 이후 기록 화면 처리로 변경 예정
      },
      image: Image.asset(
        'assets/images/clover.png',
        width: 80.w,
        height: 80.w,
        fit: BoxFit.cover,
      ),
    );
  }
}
