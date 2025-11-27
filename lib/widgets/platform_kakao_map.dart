import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kakao_map_plugin/kakao_map_plugin.dart' as mobile;
import 'package:live_frontend/models/map_model.dart';

class PlatformKakaoMap extends StatefulWidget {
  const PlatformKakaoMap({
    super.key,
    required this.centerLat,
    required this.centerLng,
    this.zoomLevel = 3,
    this.points = const <LatLngPoint>[],
    this.circles = const [],
  });

  final double centerLat;
  final double centerLng;
  final int zoomLevel;
  final List<LatLngPoint> points;
  final List<mobile.Circle> circles;

  @override
  State<PlatformKakaoMap> createState() => _PlatformKakaoMapState();
}

class _PlatformKakaoMapState extends State<PlatformKakaoMap> {
  mobile.KakaoMapController? _controller;

  @override
  void initState() {
    super.initState();
  }

  Future<List<mobile.Marker>> _buildMarkersFromPoints(
    List<LatLngPoint> points,
  ) async {
    List<mobile.Marker> markers = points
        .map(
          (p) => mobile.Marker(
            markerId: 'm_${p.lat}_${p.lng}',
            latLng: mobile.LatLng(p.lat, p.lng),
            infoWindowContent: p.label ?? '',
          ),
        )
        .toList();

    try {
      final bytes = await rootBundle.load('assets/icons/my_location.png');
      final base64Str = base64Encode(bytes.buffer.asUint8List());
      final dataUri = 'data:image/png;base64,$base64Str';

      markers.add(
        mobile.Marker(
          markerId: 'current_location',
          latLng: mobile.LatLng(widget.centerLat, widget.centerLng),
          infoWindowContent: '현재 위치',
          markerImageSrc: dataUri,
          width: 40,
          height: 40,
          zIndex: 999,
        ),
      );
    } catch (e) {
      debugPrint(
        'PlatformKakaoMap: failed to load asset for markerImageSrc: $e',
      );

      markers.add(
        mobile.Marker(
          markerId: 'current_location',
          latLng: mobile.LatLng(widget.centerLat, widget.centerLng),
          infoWindowContent: '현재 위치',
          width: 48,
          height: 48,
        ),
      );
    }

    return markers;
  }

  Future<void> _addMarkersToController(
    mobile.KakaoMapController controller,
  ) async {
    final dynamic ctrl = controller as dynamic;
    final markers = await _buildMarkersFromPoints(widget.points);

    if (markers.isEmpty) {
      debugPrint('PlatformKakaoMap: no markers to add');
      return;
    }

    final markerIds = markers.map((m) => m.markerId).toList();
    debugPrint(
      'PlatformKakaoMap: attempting to add ${markers.length} markers: $markerIds',
    );

    try {
      // clear any existing markers with same ids first to avoid duplicates
      try {
        await ctrl.clearMarker(markerIds: markerIds);
        debugPrint('PlatformKakaoMap: cleared existing markers: $markerIds');
      } catch (_) {
        // ignore if clearMarker not available
      }

      // kakao_map_plugin's controller exposes addMarker({List<Marker>? markers})
      // so call it with the named parameter.
      // print icon info for debugging
      for (final m in markers) {
        try {
          final dynIcon = m.icon as dynamic;
          debugPrint(
            'PlatformKakaoMap: marker ${m.markerId} iconType=${dynIcon?.imageType?.name} srcLength=${dynIcon?.imageSrc?.length} width=${m.width} height=${m.height}',
          );
        } catch (_) {}
      }

      await ctrl.addMarker(markers: markers);
      debugPrint('PlatformKakaoMap: addMarker(markers:) succeeded');

      try {
        final first = markers.first.latLng;
        await ctrl.panTo(first);
        debugPrint(
          'PlatformKakaoMap: panTo executed to ${first.latitude}, ${first.longitude}',
        );
      } catch (_) {}
      return;
    } catch (e) {
      debugPrint('PlatformKakaoMap: addMarker(markers:) failed: $e');
    }

    try {
      // alternative name some plugins might expose
      await ctrl.setMarkers(markers);
      return;
    } catch (_) {}

    try {
      // fallback: try per-marker add using addMarker if available
      for (final m in markers) {
        try {
          await ctrl.addMarker(m);
        } catch (_) {
          // ignore and continue
        }
      }
      return;
    } catch (e) {
      debugPrint(
        'PlatformKakaoMap: controller does not support dynamic marker methods: $e',
      );
    }
  }

  @override
  void didUpdateWidget(covariant PlatformKakaoMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.points != widget.points && _controller != null) {
      _addMarkersToController(_controller!);
    }
  }

  @override
  Widget build(BuildContext context) {
    void onMapCreated(mobile.KakaoMapController controller) {
      _controller = controller;
      _addMarkersToController(controller);
    }

    return mobile.KakaoMap(
      onMapCreated: onMapCreated,
      markers: const [],
      circles: widget.circles,
      center: mobile.LatLng(widget.centerLat, widget.centerLng),
      currentLevel: widget.zoomLevel,
    );
  }
}
