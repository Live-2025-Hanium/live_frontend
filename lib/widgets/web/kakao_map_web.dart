import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:js/js_util.dart' as jsu;

import 'package:live_frontend/env.dart';
import '../platform_kakao_map.dart'; // LatLngPoint

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
  late final String _viewType;
  late final html.DivElement _container;

  bool _ready = false;
  Object? _error;

  @override
  void initState() {
    super.initState();

    // 1) 컨테이너 준비
    _container = html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%';

    // 2) viewFactory 등록
    _viewType =
        widget.viewType ?? 'kakao-map-${DateTime.now().microsecondsSinceEpoch}';
    ui.platformViewRegistry.registerViewFactory(
      _viewType,
      (int _) => _container,
    );

    // 3) SDK 로드 후 지도 생성
    _boot();
  }

  Future<void> _boot() async {
    try {
      await _ensureKakaoMapsSdkLoaded(Env.kakaoJsAppKey);
      await _createMapAndMarkers();
      setState(() => _ready = true);
    } catch (e) {
      setState(() => _error = e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: SizedBox()),
        Positioned.fill(child: HtmlElementView(viewType: _viewType)),
        if (!_ready && _error == null)
          const Center(child: CircularProgressIndicator()),
        if (_error != null)
          Center(
            child: Text(
              'Kakao Maps init failed\n$_error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  // =============== JS SDK 로더 ===============
  Future<void> _ensureKakaoMapsSdkLoaded(String appKey) async {
    // 1. Check if already loaded
    if (jsu.hasProperty(html.window, 'kakao')) {
      final kakao = jsu.getProperty(html.window, 'kakao');
      if (jsu.hasProperty(kakao, 'maps')) {
        return; // Already loaded
      }
    }

    final completer = Completer<void>();

    // 3. Set a timeout
    final timeout = Timer(const Duration(seconds: 15), () {
      if (!completer.isCompleted) {
        completer.completeError(
          'Kakao Maps SDK timed out. Check your network connection and app key.',
        );
      }
    });

    // 2. Poll for the object
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (jsu.hasProperty(html.window, 'kakao')) {
        final kakao = jsu.getProperty(html.window, 'kakao');
        if (jsu.hasProperty(kakao, 'maps')) {
          timer.cancel();
          timeout.cancel();
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
      }
    });

    // 4. Inject the script if it doesn't exist
    if (html.document.getElementById('kakao-maps-sdk') == null) {
      if (appKey.isEmpty) {
        throw StateError(
          'KAKAO_JS_APP_KEY is empty. Pass --dart-define=KAKAO_JS_APP_KEY=...',
        );
      }

      final script = html.ScriptElement()
        ..id = 'kakao-maps-sdk'
        ..type = 'text/javascript'
        ..src =
            'https://dapi.kakao.com/v2/maps/sdk.js?autoload=false&appkey=$appKey&libraries=services,clusterer';

      script.onError.listen((_) {
        if (!completer.isCompleted) {
          timeout.cancel();
          completer.completeError('Failed to load Kakao Maps SDK script.');
        }
      });

      html.document.head!.append(script);
    }

    return completer.future;
  }

  // =============== 지도/마커 생성 ===============
  Future<void> _createMapAndMarkers() async {
    // kakao.maps.load(() => { ... })
    final kakao = jsu.getProperty(html.window, 'kakao');
    if (kakao == null)
      throw StateError('window.kakao not found (SDK not loaded?)');
    final maps = jsu.getProperty(kakao, 'maps');
    if (maps == null) throw StateError('window.kakao.maps not found');

    final loaded = Completer<void>();
    jsu.callMethod(maps, 'load', [
      jsu.allowInterop(() {
        loaded.complete();
      }),
    ]);
    await loaded.future;

    // new kakao.maps.Map(container, { center, level })
    final latLngCtor = jsu.getProperty(maps, 'LatLng');
    final mapCtor = jsu.getProperty(maps, 'Map');
    final markerCtor = jsu.getProperty(maps, 'Marker');

    final center = jsu.callConstructor(latLngCtor, [
      widget.centerLat,
      widget.centerLng,
    ]);

    final options = jsu.jsify(<String, dynamic>{
      'center': center,
      'level': widget.level,
    });

    final map = jsu.callConstructor(mapCtor, [_container, options]);

    // 포인트 → 마커
    for (final p in widget.points) {
      final pos = jsu.callConstructor(latLngCtor, [p.lat, p.lng]);
      final marker = jsu.callConstructor(markerCtor, [
        jsu.jsify({'position': pos}),
      ]);
      jsu.callMethod(marker, 'setMap', [map]);
      // label(InfoWindow)은 필요 시 추가로 구현 가능
      // final iwCtor = jsu.getProperty(maps, 'InfoWindow');
      // ...
    }
  }
}
