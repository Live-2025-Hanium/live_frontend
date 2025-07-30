import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/screens/home/execute/widgets/countdown_timer.dart';
import 'package:live_frontend/screens/home/execute/widgets/pause_modal.dart';
import 'package:live_frontend/screens/home/execute/widgets/sub_content.dart';
import 'package:live_frontend/screens/home/execute/widgets/execute_screen_template.dart';
import 'dart:async';

final CloverMissionDetailModel timerMission = CloverMissionDetailModel(
  userMissionId: 1001,
  cloverType: CloverMissionType.timer,
  missionTitle: '30분 독서하기',
  missionStatus: MissionStatus.started,
  missionDifficulty: CloverMissionDifficulty.normal,
  missionCategory: CloverMissionCategory.hobby,
  remainingTime: const Duration(minutes: 30),
  targetAddress: null,
  remainingDistance: null,
);

class ExecuteTimerMissionScreen extends StatefulWidget {
  final CloverMissionDetailModel data = timerMission;
  final int id;
  ExecuteTimerMissionScreen({super.key, required this.id});

  @override
  State<ExecuteTimerMissionScreen> createState() =>
      _ExecuteTimerMissionScreenState();
}

class _ExecuteTimerMissionScreenState extends State<ExecuteTimerMissionScreen> {
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused && _remaining.inSeconds > 0) {
        setState(() {
          _remaining -= const Duration(seconds: 1);
          if (_remaining.inSeconds == 0) {
            _timer?.cancel();
          }
        });
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

  void _showPauseModal() {
    showDialog(
      context: context,
      builder: (_) => PauseModal(
        userMissionId: widget.data.userMissionId,
        onConfirm: () {
          context.goNamed('home');
        },
        onCancel: () {
          _togglePause();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mission = widget.data;

    return ExecuteScreenTemplate(
      missionTitle: mission.missionTitle,
      imagePath: 'assets/images/clover_mission/timer.png',
      leftLabel: _isPaused ? '다시 시작' : '일시정지',
      onLeftPressed: () {
        _togglePause();
        _showPauseModal();
      },
      rightLabel: '완료',
      onRightPressed: () {
        // 완료 처리 로직
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubContent(
            subtitle: '앞으로 남은 시간',
            child: CountdownTimer(formattedTime: _formatDuration(_remaining)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
