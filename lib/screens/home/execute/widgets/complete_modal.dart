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
  late final Map<String, dynamic> _providerParam;

  @override
  void initState() {
    super.initState();
    // 위젯이 생성될 때 프로바이더에 전달할 파라미터를 한 번만 생성합니다.
    _providerParam = {
      'status': MissionStatus.completed,
      'missionId': widget.userMissionId,
    };
  }

  @override
  Widget build(BuildContext context) {
    // provider를 한 번만 조회하여 watch와 listen에 동일한 인스턴스를 사용합니다.
    final provider = cloverMissionStateUpdateProvider(_providerParam);

    ref.listen(provider, (previous, next) {
      // 에러 상태가 되면 스낵바를 표시하고 모달을 닫습니다.
      if (next is AsyncError && mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('미션 완료에 실패했습니다. 다시 시도해주세요.')),
        // );
        SaeipToastController.showMessage(context, '미션 완료에 실패했습니다. 다시 시도해주세요.');
        context.pop();
      }
    });

    final cloverMissionStateUpdateAsync = ref.watch(provider);

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
        return const Center(child: CircularProgressIndicator());
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
