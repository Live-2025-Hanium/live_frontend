import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';
import 'package:live_frontend/providers/home_provider.dart';

class CompleteModal extends ConsumerStatefulWidget {
  final int userMissionId;
  const CompleteModal({super.key, required this.userMissionId});

  @override
  ConsumerState<CompleteModal> createState() => _CompleteModalState();
}

class _CompleteModalState extends ConsumerState<CompleteModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 실행 시 미션을 완료 처리합니다.
      ref
          .read(cloverMissionNotifierProvider.notifier)
          .completeMission(widget.userMissionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SaeipModal.image(
      title: '미션 완료',
      message: '오늘의 클로버를 획득했어요.',
      confirmText: '기록하기',
      onConfirm: () {
        context.goNamed('mission_record'); // 임시 처리 이후 기록 화면 처리로 변경 예정
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
