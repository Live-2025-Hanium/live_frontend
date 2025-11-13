import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:kakao_map_plugin/kakao_map_plugin.dart' as mobile;

import 'web/kakao_map_stub.dart'
    if (dart.library.html) 'web/kakao_map_web.dart';

class LatLngPoint {
  final double lat;
  final double lng;
  final String? label;
  const LatLngPoint(this.lat, this.lng, {this.label});
}

/// 단일 위젯으로 플랫폼 분기
class PlatformKakaoMap extends StatelessWidget {
  const PlatformKakaoMap({
    super.key,
    required this.centerLat,
    required this.centerLng,
    this.zoomLevel = 3,
    this.points = const <LatLngPoint>[],
    this.onMapCreated,
    this.circles = const [],
  });

  final double centerLat;
  final double centerLng;
  final int zoomLevel;
  final List<LatLngPoint> points;
  final void Function(mobile.KakaoMapController controller)? onMapCreated;
  final List<mobile.Circle> circles;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // 웹: JS SDK 직결
      return KakaoMapWeb(
        centerLat: centerLat,
        centerLng: centerLng,
        level: zoomLevel,
        points: points,
      );
    }

    // 모바일: kakao_map_plugin 그대로
    final markers = points.map((p) {
      return mobile.Marker(
        markerId: 'm_${p.lat}_${p.lng}',
        latLng: mobile.LatLng(p.lat, p.lng),
        infoWindowContent: p.label ?? '',
      );
    }).toList();

    return mobile.KakaoMap(
      onMapCreated: onMapCreated,
      markers: markers,
      circles: circles,
      center: mobile.LatLng(centerLat, centerLng),
      currentLevel: zoomLevel,
    );
  }
}
