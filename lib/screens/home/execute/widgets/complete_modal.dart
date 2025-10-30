import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/providers/clover_mission_provider.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';

class CompleteModal extends ConsumerStatefulWidget {
  final int userMissionId;
  const CompleteModal({super.key, required this.userMissionId});

  @override
  ConsumerState<CompleteModal> createState() => _CompleteModalState();
}

class _CompleteModalState extends ConsumerState<CompleteModal> {
  // 프로바이더를 저장할 변수를 선언합니다.
  late final updateProvider;

  @override
  void initState() {
    super.initState();
    // initState에서 위젯이 생성될 때 프로바이더를 한 번만 초기화합니다.
    updateProvider = cloverMissionStateUpdateProvider({
      'status': MissionStatus.completed,
      'missionId': widget.userMissionId,
    });
    // 초기 API 요청을 트리거합니다.
    ref.read(updateProvider);
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen으로 side-effect(화면 닫기 등)를 처리합니다.
    ref.listen(updateProvider, (previous, next) {
      // 에러 상태가 되면 다이얼로그를 닫습니다.
      if (next is AsyncError && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.pop();
        });
      }
    });

    // ref.watch로 프로바이더의 상태를 구독하여 UI를 빌드합니다.
    final cloverMissionStateUpdateAsync = ref.watch(updateProvider);

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
        // listen에서 화면을 닫으므로, 여기서는 간단한 UI만 보여주거나 비워둡니다.
        return const Center(child: Text('오류 발생'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
