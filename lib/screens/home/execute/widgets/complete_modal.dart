import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/providers/clover_mission_provider.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';
import 'package:live_frontend/widgets/utils/show_saeip_toast.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final cloverMissionStateUpdateAsync = ref.read(
      cloverMissionStateUpdateProvider({
        'missionStatus': MissionStatus.completed,
        'userMissionId': widget.userMissionId,
      }),
    );
    return cloverMissionStateUpdateAsync.when(
      data: (_) {
        return SaeipModal.image(
          title: '미션 완료',
          message: '오늘의 클로버를 획득했어요.',
          confirmText: '확인',
          onConfirm: () async {
            context.goNamed('mission_record'); // 임시 처리 이후 기록 화면 처리로 변경 예정
          },
          cancelText: '닫기',
          onCancel: () {
            context.goNamed('home'); // 임시 처리 이후 기록 화면 처리로 변경 예정
          },
          image: Image.asset(
            'assets/images/clover.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        );
      },
      error: (error, stack) {
        SaeipToastController.showMessage(context, '미션 상태 업데이트 중 오류가 발생하였습니다.');
        context.pop();
        return const SizedBox.shrink();
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
