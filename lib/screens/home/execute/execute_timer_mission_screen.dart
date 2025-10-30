import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/providers/clover_mission_provider.dart';
import 'package:live_frontend/screens/home/execute/widgets/complete_modal.dart';
import 'package:live_frontend/screens/home/execute/widgets/countdown_timer.dart';
import 'package:live_frontend/screens/home/execute/widgets/pause_modal.dart';
import 'package:live_frontend/screens/home/execute/widgets/sub_content.dart';
import 'package:live_frontend/screens/home/execute/widgets/execute_screen_template.dart';
import 'dart:async';

import 'package:live_frontend/widgets/saeip_modal.dart';

class ExecuteTimerMissionScreen extends ConsumerStatefulWidget {
  final int id;
  const ExecuteTimerMissionScreen({super.key, required this.id});

  @override
  ConsumerState<ExecuteTimerMissionScreen> createState() =>
      _ExecuteTimerMissionScreenState();
}

class _ExecuteTimerMissionScreenState
    extends ConsumerState<ExecuteTimerMissionScreen> {
  late Duration _remaining;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
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
        userMissionId: widget.id,
        onCancel: () {
          _togglePause();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final missionDetailAsync = ref.watch(
      cloverMissionDetailProvider(widget.id),
    );
    final onRightPressed = _remaining.inSeconds > 0
        ? () {
            _togglePause();
            showDialog(
              context: context,
              builder: (context) {
                return _buildEarlyCompletionModal();
              },
            );
          }
        : () {
            showDialog(
              context: context,
              builder: (context) {
                return CompleteModal(userMissionId: widget.id);
              },
            );
          };
    return missionDetailAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
      data: (detail) {
        if (detail == null || detail.remainingTime == null) {
          return Scaffold(body: Center(child: Text('미션 정보를 불러올 수 없습니다.')));
        }
        _remaining = detail.remainingTime!;
        _startTimer();
        return ExecuteScreenTemplate(
          missionTitle: detail.missionTitle,
          imagePath: 'assets/images/clover_mission/timer.png',
          onLeftPressed: () {
            _togglePause();
            _showPauseModal();
          },
          rightLabel: '완료',
          onRightPressed: onRightPressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubContent(
                subtitle: '앞으로 남은 시간',
                child: CountdownTimer(
                  formattedTime: _formatDuration(_remaining),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildEarlyCompletionModal() {
    return SaeipModal(
      title: '아직 시간이 남았어요!',
      message: '미션을 일찍 완료하셨나요?',
      confirmText: '완료',
      onConfirm: () {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) {
            return CompleteModal(userMissionId: widget.id);
          },
        );
      },
      cancelText: '취소',
      onCancel: () {
        _togglePause();
        Navigator.of(context).pop();
      },
    );
  }
}
