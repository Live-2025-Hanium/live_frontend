import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kakao_map_plugin/kakao_map_plugin.dart' as mobile;
import 'package:live_frontend/utilities/location_util.dart';
import 'package:live_frontend/models/map_model.dart';

class PlatformKakaoMap extends StatefulWidget {
  const PlatformKakaoMap({
    super.key,
    this.centerLat,
    this.centerLng,
    this.zoomLevel = 3,
    this.points = const <LatLngPoint>[],
    this.circles = const [],
  });

  // If these are null, the widget will attempt to use the device's current
  // location as the center.
  final double? centerLat;
  final double? centerLng;
  final int zoomLevel;
  final List<LatLngPoint> points;
  final List<mobile.Circle> circles;

  @override
  State<PlatformKakaoMap> createState() => _PlatformKakaoMapState();
}

class _PlatformKakaoMapState extends State<PlatformKakaoMap> {
  mobile.KakaoMapController? _controller;
  double? _effectiveLat;
  double? _effectiveLng;

  @override
  void initState() {
    super.initState();
    // Resolve the effective center: prefer provided props, otherwise try device
    // location and finally fall back to a sensible default.
    _resolveCenterAndUpdate();
  }

  Future<void> _resolveCenterAndUpdate() async {
    double? lat = widget.centerLat;
    double? lng = widget.centerLng;

    if (lat == null || lng == null) {
      try {
        final pos = await getCurrentLocation();
        if (pos != null) {
          lat = pos.latitude;
          lng = pos.longitude;
        }
      } catch (e) {
        debugPrint('PlatformKakaoMap: error fetching device location: $e');
      }
    }

    // final fallback
    lat ??= 37.5;
    lng ??= 127.0;

    final changed = lat != _effectiveLat || lng != _effectiveLng;
    if (changed) {
      setState(() {
        _effectiveLat = lat;
        _effectiveLng = lng;
      });

      // If controller is already available, update marker and pan
      if (_controller != null) {
        try {
          await _addOrUpdateCurrentLocationMarker(_controller!);
          try {
            final dynamic ctrl = _controller as dynamic;
            await ctrl.panTo(mobile.LatLng(_effectiveLat!, _effectiveLng!));
          } catch (_) {}
        } catch (e) {
          debugPrint(
            'PlatformKakaoMap: failed to update map after resolving center: $e',
          );
        }
      }
    }
  }

  Future<List<mobile.Marker>> _buildMarkersFromPoints(
    List<LatLngPoint> points,
  ) async {
    // Build markers from provided points only. Current location marker is
    // handled separately to guarantee it always exists and can be updated
    // independently of the points list.
    final markers = points
        .map(
          (p) => mobile.Marker(
            markerId: 'm_${p.lat}_${p.lng}',
            latLng: mobile.LatLng(p.lat, p.lng),
            infoWindowContent: p.label ?? '',
          ),
        )
        .toList();

    return markers;
  }

  Future<mobile.Marker> _buildCurrentLocationMarker() async {
    try {
      final bytes = await rootBundle.load('assets/icons/my_location.png');
      final base64Str = base64Encode(bytes.buffer.asUint8List());
      final dataUri = 'data:image/png;base64,$base64Str';

      return mobile.Marker(
        markerId: 'current_location',
        latLng: mobile.LatLng(
          _effectiveLat ?? widget.centerLat ?? 37.5,
          _effectiveLng ?? widget.centerLng ?? 127.0,
        ),
        infoWindowContent: '현재 위치',
        markerImageSrc: dataUri,
        width: 40,
        height: 40,
        zIndex: 999,
      );
    } catch (e) {
      debugPrint(
        'PlatformKakaoMap: failed to load asset for current marker: $e',
      );

      return mobile.Marker(
        markerId: 'current_location',
        latLng: mobile.LatLng(
          _effectiveLat ?? widget.centerLat ?? 37.5,
          _effectiveLng ?? widget.centerLng ?? 127.0,
        ),
        infoWindowContent: '현재 위치',
        width: 48,
        height: 48,
      );
    }
  }

  Future<void> _addMarkersToController(
    mobile.KakaoMapController controller,
  ) async {
    final dynamic ctrl = controller as dynamic;
    final markers = await _buildMarkersFromPoints(widget.points);

    final markerIds = markers.map((m) => m.markerId).toList();
    debugPrint(
      'PlatformKakaoMap: attempting to add ${markers.length} markers: $markerIds',
    );

    try {
      // clear any existing markers with same ids first to avoid duplicates
      if (markerIds.isNotEmpty) {
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

        try {
          await ctrl.addMarker(markers: markers);
          debugPrint('PlatformKakaoMap: addMarker(markers:) succeeded');
        } catch (e) {
          debugPrint('PlatformKakaoMap: addMarker(markers:) failed: $e');
          try {
            await ctrl.setMarkers(markers);
            debugPrint('PlatformKakaoMap: setMarkers(markers) succeeded');
          } catch (_) {
            // fallback to per-marker add
            for (final m in markers) {
              try {
                await ctrl.addMarker(m);
              } catch (_) {
                // ignore and continue
              }
            }
          }
        }

        try {
          final first = markers.first.latLng;
          await ctrl.panTo(first);
          debugPrint(
            'PlatformKakaoMap: panTo executed to ${first.latitude}, ${first.longitude}',
          );
        } catch (_) {}
      } else {
        debugPrint('PlatformKakaoMap: no point markers to add');
      }
    } catch (e) {
      debugPrint('PlatformKakaoMap: controller marker operations failed: $e');
    }

    // Always ensure the current location marker exists / is updated.
    try {
      await _addOrUpdateCurrentLocationMarker(controller);
    } catch (e) {
      debugPrint('PlatformKakaoMap: failed to add/update current marker: $e');
    }
  }

  Future<void> _addOrUpdateCurrentLocationMarker(
    mobile.KakaoMapController controller,
  ) async {
    final dynamic ctrl = controller as dynamic;
    final marker = await _buildCurrentLocationMarker();

    try {
      // try clearing existing current marker id first
      try {
        await ctrl.clearMarker(markerIds: [marker.markerId]);
        debugPrint(
          'PlatformKakaoMap: cleared existing current_location marker',
        );
      } catch (_) {
        // ignore if not available
      }

      // attempt to add via common APIs
      try {
        await ctrl.addMarker(markers: [marker]);
        debugPrint(
          'PlatformKakaoMap: added current_location via addMarker(markers:)',
        );
        return;
      } catch (_) {}

      try {
        await ctrl.setMarkers([marker]);
        debugPrint('PlatformKakaoMap: added current_location via setMarkers');
        return;
      } catch (_) {}

      try {
        await ctrl.addMarker(marker);
        debugPrint(
          'PlatformKakaoMap: added current_location via addMarker(single)',
        );
        return;
      } catch (e) {
        debugPrint(
          'PlatformKakaoMap: failed to add current_location marker: $e',
        );
      }
    } catch (e) {
      debugPrint(
        'PlatformKakaoMap: unexpected error updating current marker: $e',
      );
    }
  }

  @override
  void didUpdateWidget(covariant PlatformKakaoMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If points list changed, refresh point markers.
    if (oldWidget.points != widget.points && _controller != null) {
      _addMarkersToController(_controller!);
    }

    // If explicit center props changed, or if previously null and now set,
    // resolve and update the effective center.
    if (oldWidget.centerLat != widget.centerLat ||
        oldWidget.centerLng != widget.centerLng) {
      _resolveCenterAndUpdate();
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
      center: mobile.LatLng(
        _effectiveLat ?? widget.centerLat ?? 37.5,
        _effectiveLng ?? widget.centerLng ?? 127.0,
      ),
      currentLevel: widget.zoomLevel,
    );
  }
}
