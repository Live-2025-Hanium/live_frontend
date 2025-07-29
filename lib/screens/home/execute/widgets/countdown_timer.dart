import 'dart:async';
import 'package:flutter/material.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class CountdownTimer extends StatefulWidget {
  final Duration remainingTime;
  const CountdownTimer({super.key, required this.remainingTime});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _duration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _duration = widget.remainingTime;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_duration.inSeconds > 0) {
        setState(() {
          _duration = _duration - const Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String get _formattedTime {
    final minutes = _duration.inMinutes;
    final seconds = _duration.inSeconds.remainder(60);
    return '${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: responsiveFont(50, min: 36, max: 56) * 3,
      child: Text(
        _formattedTime,
        textAlign: TextAlign.left, // ← 왼쪽 붙이기
        textWidthBasis: TextWidthBasis.longestLine, // ← 박스 폭을 최장행에 맞춤
        style: TextStyle(
          fontFamily: 'Pretendard',
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: responsiveFont(50, min: 36, max: 56),
          height: 56 / 50,
          fontFeatures: [FontFeature.tabularFigures()], // ← 숫자 고정폭
          // letterSpacing: -0.5,                          // ← 필요 시 미세 조정
        ),
      ),
    );
  }
}
