import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:live_frontend/screens/map/map_search_screen.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'widgets/category_bottom_sheet.dart';
import 'package:live_frontend/widgets/platform_kakao_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _searchController = TextEditingController();

  KakaoMapController? _mapController;
  final _sheetController = DraggableScrollableController();

  // 화면에 그릴 마커/서클 목록
  List<Marker> _markers = [];
  List<Circle> _circles = [];

  // 현재 위치(예시)
  static final myLocation = LatLng(37.611846, 126.834059);

  // 카테고리 액션들
  static const categoryItems = [
    CategoryAction(
      iconAsset: 'assets/icons/map_category/leisure.svg',
      label: '여가시설',
      query: '여가시설',
    ),
    CategoryAction(
      iconAsset: 'assets/icons/map_category/mental_clinic.svg',
      label: '정신건강과',
      query: '정신건강의학과',
    ),
    CategoryAction(
      iconAsset: 'assets/icons/map_category/welfare_center.svg',
      label: '복지기관',
      query: '복지관',
    ),
    CategoryAction(
      iconAsset: 'assets/icons/map_category/counseling_center.svg',
      label: '상담센터',
      query: '상담센터',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // 초기 마커
    _markers = [
      Marker(
        markerId: 'my_location',
        latLng: myLocation,
        markerImageSrc: 'assets/icons/my_location.svg',
        width: 40,
        height: 40,
      ),
    ];

    // SVG 비주얼을 Circle 두 개로 재현 (지도의 단위는 '미터')
    const int outerRadiusM = 25;
    const int innerRadiusM = 10;

    _circles = [
      // 바깥 원: #F294A3, opacity 0.5
      Circle(
        circleId: 'pink_outer',
        center: myLocation,
        radius: outerRadiusM.toDouble(),
        fillColor: const Color(0xFFF294A3),
        fillOpacity: 0.5, // fillOpacity를 높게 설정
        strokeWidth: 2, // 테두리 추가 (디버깅용)
        strokeOpacity: 1.0,
      ),
      // 안쪽 원: #DA8593 + 흰색 테두리 2px
      Circle(
        circleId: 'pink_inner',
        center: myLocation,
        radius: innerRadiusM.toDouble(),
        fillColor: const Color(0xFFDA8593),
        fillOpacity: 1.0,
        strokeColor: Colors.white, // 테두리 색상 변경 (디버깅용)
        strokeWidth: 3,
        strokeOpacity: 1.0,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // dio 없이 동작하는 "모의 검색": 현재 위치 주변에 임의 마커 생성
  Future<void> _mockSearchByCategory(CategoryAction action) async {
    final center = myLocation;

    // 중심 기준으로 살짝씩 오프셋된 좌표들을 생성(더미)
    const deltas = <(double, double)>[
      (0.003, 0.002),
      (-0.002, 0.003),
      (0.0015, -0.0025),
      (-0.003, -0.0015),
      (0.0022, 0.0035),
      (-0.0022, 0.0018),
    ];

    final newMarkers = <Marker>[
      // 현재 위치 마커 먼저 추가
      Marker(
        markerId: 'my_location',
        latLng: myLocation,
        markerImageSrc: 'assets/icons/my_location.svg',
        width: 40,
        height: 40,
      ),
    ];

    // 검색 결과 마커 추가
    for (var i = 0; i < deltas.length; i++) {
      final (dy, dx) = deltas[i];
      final lat = center.latitude + dy;
      final lng = center.longitude + dx;
      newMarkers.add(
        Marker(
          markerId: '${action.label}_$i',
          latLng: LatLng(lat, lng),
          infoWindowContent: '${action.label} #$i',
        ),
      );
    }

    setState(() => _markers = newMarkers);

    // 지도 중심 이동
    if (_mapController != null) {
      await _mapController!.setCenter(center);
    }

    // 바텀시트가 닫혀있다면 살짝 열기
    if (_sheetController.size < 0.35) {
      // ignore: unawaited_futures
      _sheetController.animateTo(
        0.35,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 하단 네비와 겹치지 않도록 여백
    const bottomNavGap = kBottomNavigationBarHeight + 12.0;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PlatformKakaoMap(
              centerLat: 37.611846,
              centerLng: 126.834059,
              zoomLevel: 3,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              points: _markers
                  .map(
                    (marker) => LatLngPoint(
                      marker.latLng.latitude,
                      marker.latLng.longitude,
                      label: marker.infoWindowContent,
                    ),
                  )
                  .toList(),
              circles: _circles,
            ),
          ),

          // 검색바(탭 시 검색 화면으로 이동)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MapSearchScreen(),
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: SaeipSearchBar(
                    controller: _searchController,
                    hintText: '장소, 주소 검색',
                    onSubmit: (value) {},
                    logoSvgAsset: 'assets/icons/clover.svg',
                  ),
                ),
              ),
            ),
          ),

          // 현재 위치로 이동 버튼
          Positioned(
            right: 16,
            bottom: bottomNavGap + 95,
            child: GestureDetector(
              onTap: () {
                if (_mapController != null) {
                  _mapController!.setCenter(myLocation);
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)],
                ),
                child: SvgPicture.asset('assets/icons/reset_location.svg'),
              ),
            ),
          ),

          // 카테고리 선택 바텀시트
          CategoryBottomSheet(
            items: categoryItems,
            controller: _sheetController,
            onCategoryTap: _mockSearchByCategory,
          ),

          // (선택) 하단 정보 영역 자리(애니메이션 컨테이너)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, bottomNavGap),
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 0, // 검색 결과 있을 때 200 등으로 변경
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(blurRadius: 12, color: Colors.black26),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 2),
    );
  }
}
