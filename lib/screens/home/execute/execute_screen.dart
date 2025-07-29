import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/screens/home/execute/widgets/sub_content.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';
import 'dart:async';

// 아래는 임시 데이터들... api 연결 이후 삭제
// 1. TIMER 타입 미션
final CloverMissionDetailModel timerMission = CloverMissionDetailModel(
  userMissionId: 1,
  cloverType: CloverMissionType.timer,
  missionTitle: '30분 독서하기',
  description: '좋은 책을 읽으며 지식을 쌓아보세요. 집중력 향상에도 도움이 됩니다.',
  missionStatus: MissionStatus.assigned,
  missionDifficulty: CloverMissionDifficulty.easy,
  missionCategory: CloverMissionCategory.study,
  remainingTime: Duration(minutes: 30, seconds: 0),
);

// 3. VISIT 타입 미션
final CloverMissionDetailModel visitMission = CloverMissionDetailModel(
  userMissionId: 3,
  cloverType: CloverMissionType.visit,
  missionTitle: '가까운 카페 방문하기',
  description: '새로운 장소를 탐방하며 일상에 변화를 주어보세요. 맛있는 커피도 함께 즐겨보세요.',
  missionStatus: MissionStatus.assigned,
  missionDifficulty: CloverMissionDifficulty.veryEasy,
  missionCategory: CloverMissionCategory.hobby,
  targetAddress: '서울시 강남구 테헤란로 123 스타벅스',
);

// 4. PHOTO 타입 미션
final CloverMissionDetailModel photoMission = CloverMissionDetailModel(
  userMissionId: 4,
  cloverType: CloverMissionType.photo,
  missionTitle: '동료와 점심 사진 찍기',
  description: '소중한 동료들과 함께 점심을 먹고 추억을 남겨보세요. 인간관계도 더욱 돈독해질 거예요.',
  missionStatus: MissionStatus.completed,
  missionDifficulty: CloverMissionDifficulty.hard,
  missionCategory: CloverMissionCategory.relationship,
);

class ExecuteScreen extends StatefulWidget {
  final data = timerMission; // 임시로 timerMission을 사용
  ExecuteScreen({super.key});

  @override
  State<ExecuteScreen> createState() => _ExecuteScreenState();
}

class _ExecuteScreenState extends State<ExecuteScreen> {
  late Duration _remaining;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.data.remainingTime ?? Duration.zero;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_isPaused && _remaining.inSeconds > 0) {
        setState(() {
          _remaining -= const Duration(seconds: 1);
        });
      }
      if (_remaining.inSeconds == 0) {
        _timer?.cancel();
      }
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String get _formattedTime {
    final m = _remaining.inMinutes;
    final s = _remaining.inSeconds.remainder(60);
    return '${_twoDigits(m)}:${_twoDigits(s)}';
  }

  @override
  Widget build(BuildContext context) {
    String image = '';
    String buttonRightLabel = '완료';

    switch (widget.data.cloverType) {
      case CloverMissionType.timer:
        image = 'assets/images/clover_mission/timer.png';
        break;
      case CloverMissionType.distance:
        image = 'assets/images/clover_mission/distance.png';
        break;
      case CloverMissionType.visit:
        image =
            'assets/images/clover_mission/distance.png'; // 임시로 distance 이미지 사용
        break;
      case CloverMissionType.photo:
        image = 'assets/images/clover_mission/photo.png';
        buttonRightLabel = '인증샷 촬영';
        break;
    }
    return Scaffold(
      appBar: SaeipAppBar(title: '미션 수행'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.missionTitle,
                      style: AppTextStyles.titleMedium(
                        context,
                        color: AppColors.greenNormal,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Gap(4.h),
                    Text('미션을 진행 중이에요.'),
                    Gap(16.h),
                    SizedBox(width: double.infinity, child: Image.asset(image)),
                    Gap(24.h),
                    if (widget.data.cloverType != CloverMissionType.photo)
                      SubContent(
                        cloverType: widget.data.cloverType,
                        formattedTime: _formattedTime,
                        targetAddress: widget.data.targetAddress,
                        remainingDistance: widget.data.remainingDistance,
                      ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SaeipButton.outlined(
                      text: '일시정지',
                      outlineColor: AppColors.blackBlack2,
                      onPressed: () {
                        _togglePause();
                        showDialog(
                          context: context,
                          builder: (context) => _buildPauseModal(context),
                        );
                      },
                    ),
                  ),
                  Gap(8.w),
                  Expanded(
                    child: SaeipButton(
                      text: buttonRightLabel,
                      onPressed: () {
                        // 인증샷 촬영
                        // 완료 모달 띄우기
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPauseModal(BuildContext context) {
    return SaeipModal(
      title: '미션 중단',
      message: '괜찮아요. 다음에 다시 시작할 수 있어요.',
      onConfirm: () {
        // 일시정지 api 보내기
        context.goNamed('home'); // 홈으로 이동
      },
      onCancel: () {
        // 일시정지 취소
        _togglePause(); // 일시정지 상태 되돌리기
        context.pop();
      },
      confirmText: '다음에 하기',
      cancelText: '다시 시작',
      confirmBackgroundColor: AppColors.errorError3,
    );
  }
}
