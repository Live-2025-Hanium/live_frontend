import 'package:flutter/material.dart';
import '../platform_kakao_map.dart'; // For LatLngPoint

class KakaoMapWeb extends StatefulWidget {
  const KakaoMapWeb({
    super.key,
    required this.centerLat,
    required this.centerLng,
    this.level = 3,
    this.points = const <LatLngPoint>[],
    this.viewType,
  });

  final double centerLat;
  final double centerLng;
  final int level;
  final List<LatLngPoint> points;
  final String? viewType;

  @override
  State<KakaoMapWeb> createState() => _KakaoMapWebState();
}

class _KakaoMapWebState extends State<KakaoMapWeb> {
  @override
  Widget build(BuildContext context) {
    // This should not be rendered on mobile platforms because of the kIsWeb check.
    // This is a stub to make the compiler happy.
    return const Center(
      child: Text(
        'Kakao Map is only available on Web.',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
