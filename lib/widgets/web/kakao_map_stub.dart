import 'package:flutter/material.dart';
import '../platform_kakao_map.dart';

class KakaoMapWeb extends StatelessWidget {
  final double centerLat;
  final double centerLng;
  final int level;
  final List<LatLngPoint> points;

  const KakaoMapWeb({
    super.key,
    required this.centerLat,
    required this.centerLng,
    required this.level,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    // 모바일/데스크탑에서 웹 뷰는 의미 없음 → 빈 위젯 반환
    return const SizedBox.shrink();
  }
}