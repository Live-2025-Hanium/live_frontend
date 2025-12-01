import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart' as mobile;
import 'package:live_frontend/models/map_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/providers/map_location_provider.dart';
import 'package:live_frontend/core/services/map_manager.dart';

class PlatformKakaoMap extends ConsumerStatefulWidget {
  const PlatformKakaoMap({
    super.key,
    this.zoomLevel = 3,
    this.points = const <LatLngPoint>[],
    this.circles = const [],
    this.onMapReady,
  });

  final int zoomLevel;
  final List<LatLngPoint> points;
  final List<mobile.Circle> circles;
  final VoidCallback? onMapReady;

  @override
  ConsumerState<PlatformKakaoMap> createState() => _PlatformKakaoMapState();
}

class _PlatformKakaoMapState extends ConsumerState<PlatformKakaoMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PlatformKakaoMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 마커리스트가 바뀌면 포인트 마커 갱신
    if (oldWidget.points != widget.points &&
        MapManager.instance.isInitialized) {
      MapManager.instance.addMarkersFromPoints(widget.points);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<MapLocationState>(mapLocationProvider, (prev, next) {
      if (!MapManager.instance.isInitialized) return;

      if (next.centerLatitude != null && next.centerLongitude != null) {
        MapManager.instance.setCenter(
          next.centerLatitude!,
          next.centerLongitude!,
        );
      }

      if (next.currentLatitude != null && next.currentLongitude != null) {
        MapManager.instance.addOrUpdateCurrentLocationMarker(
          latitude: next.currentLatitude!,
          longitude: next.currentLongitude!,
        );
      }
    });

    void onMapCreated(mobile.KakaoMapController controller) {
      MapManager.instance.initialize(controller);

      // 초기 맵 마커 추가
      MapManager.instance.addMarkersFromPoints(widget.points);

      // 프로바이더 상태 즉시 적용 // loc = locationState
      final loc = ref.read(mapLocationProvider);
      if (loc.centerLatitude != null && loc.centerLongitude != null) {
        MapManager.instance.setCenter(
          loc.centerLatitude!,
          loc.centerLongitude!,
        );
      }
      if (loc.currentLatitude != null && loc.currentLongitude != null) {
        MapManager.instance.addOrUpdateCurrentLocationMarker(
          latitude: loc.currentLatitude!,
          longitude: loc.currentLongitude!,
        );
      }

      // notify parent that map is ready
      widget.onMapReady?.call();
    }

    final loc = ref.watch(mapLocationProvider);
    final centerLat = loc.centerLatitude ?? loc.currentLatitude ?? 37.5;
    final centerLng = loc.centerLongitude ?? loc.currentLongitude ?? 127.0;

    return mobile.KakaoMap(
      onMapCreated: onMapCreated,
      markers: const [],
      circles: widget.circles,
      center: mobile.LatLng(centerLat, centerLng),
      currentLevel: widget.zoomLevel,
    );
  }
}
