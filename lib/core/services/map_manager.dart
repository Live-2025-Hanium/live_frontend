import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:kakao_map_plugin/kakao_map_plugin.dart' as mobile;
import 'package:live_frontend/models/map_model.dart';

class MapManager {
  MapManager._internal();

  static final MapManager instance = MapManager._internal();

  mobile.KakaoMapController? _controller;

  bool get isInitialized => _controller != null;

  void initialize(mobile.KakaoMapController controller) {
    _controller = controller;
  }

  mobile.KakaoMapController? get controller => _controller;

  Future<void> setCenter(double latitude, double longitude) async {
    if (_controller == null) return;
    try {
      final ctrl = _controller as dynamic;
      await ctrl.panTo(mobile.LatLng(latitude, longitude));
    } catch (_) {}
  }

  Future<void> addMarkersFromPoints(List<LatLngPoint> points) async {
    if (_controller == null) return;

    final markers = points
        .map(
          (p) => mobile.Marker(
            markerId: 'm_${p.lat}_${p.lng}',
            latLng: mobile.LatLng(p.lat, p.lng),
            infoWindowContent: p.label ?? '',
          ),
        )
        .toList();

    if (markers.isEmpty) return;

    final markerIds = markers.map((m) => m.markerId).toList();
    try {
      final ctrl = _controller as dynamic;
      try {
        await ctrl.clearMarker(markerIds: markerIds);
      } catch (_) {}

      try {
        await ctrl.addMarker(markers: markers);
      } catch (e) {
        try {
          await ctrl.setMarkers(markers);
        } catch (_) {
          for (final m in markers) {
            try {
              await ctrl.addMarker(m);
            } catch (_) {}
          }
        }
      }

      // move camera to first marker
      try {
        final first = markers.first.latLng;
        await ctrl.panTo(first);
      } catch (_) {}
    } catch (_) {}
  }

  Future<void> addOrUpdateCurrentLocationMarker({
    required double latitude,
    required double longitude,
  }) async {
    if (_controller == null) return;

    final marker = await _buildCurrentLocationMarker(latitude, longitude);

    try {
      final ctrl = _controller as dynamic;
      try {
        await ctrl.clearMarker(markerIds: [marker.markerId]);
      } catch (_) {}

      try {
        await ctrl.addMarker(markers: [marker]);
        return;
      } catch (_) {}

      try {
        await ctrl.setMarkers([marker]);
        return;
      } catch (_) {}

      try {
        await ctrl.addMarker(marker);
        return;
      } catch (_) {}
    } catch (_) {}
  }

  Future<mobile.Marker> _buildCurrentLocationMarker(
    double lat,
    double lng,
  ) async {
    try {
      final bytes = await rootBundle.load('assets/icons/my_location.png');
      final base64Str = base64Encode(bytes.buffer.asUint8List());
      final dataUri = 'data:image/png;base64,$base64Str';

      return mobile.Marker(
        markerId: 'current_location',
        latLng: mobile.LatLng(lat, lng),
        infoWindowContent: '현재 위치',
        markerImageSrc: dataUri,
        width: 40,
        height: 40,
        zIndex: 999,
      );
    } catch (_) {
      return mobile.Marker(
        markerId: 'current_location',
        latLng: mobile.LatLng(lat, lng),
        infoWindowContent: '현재 위치',
        width: 48,
        height: 48,
      );
    }
  }
}
