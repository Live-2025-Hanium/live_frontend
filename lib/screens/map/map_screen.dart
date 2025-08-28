import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:live_frontend/screens/map/map_search_screen.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'widgets/category_bottom_sheet.dart'; // CategoryBottomSheet, CategoryAction

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _searchController = TextEditingController();

  KakaoMapController? _mapController;
  final _sheetController = DraggableScrollableController();

  // 화면에 그릴 마커 목록(더미)
  List<Marker> _markers = [];

  // 현재 위치 상수 추가
  static const myLocation = LatLng(37.611846, 126.834059);

  // 상수로 분리하여 관리 (나중에 설정 파일이나 API로 이동 가능)
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
    // 초기 마커 설정
    _markers = [
      Marker(
        markerId: 'my_location',
        latLng: myLocation,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // dio 없이 동작하는 "모의 검색": 현재 중심 주변에 임의 마커 생성
  Future<void> _mockSearchByCategory(CategoryAction action) async {
    // 현재 위치 기준으로 검색
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
      ),
    ];

    // 검색 결과 마커 추가
    for (var i = 0; i < deltas.length; i++) {
      final (dy, dx) = deltas[i];
      final lat = center.latitude + dy;
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
    // 하단 네비와 겹치지 않도록 여백 계산 (필요 시 조정)
    const bottomNavGap = kBottomNavigationBarHeight + 12.0;

    return Scaffold(
      //extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: KakaoMap(
              markers: _markers,
              onMapCreated: (c) => _mapController = c,
              center: LatLng(37.611846, 126.834059),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MapSearchScreen()),
                  );
                },
                child: AbsorbPointer(
                  child: SaeipSearchBar(
                    controller: _searchController,
                    hintText: '장소, 주소 검색',
                    onSubmit: (value) {
                      // 검색바를 탭했을 때는 이 콜백이 호출되지 않음
                    },
                    logoSvgAsset: 'assets/icons/clover.svg',
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: 16,
            bottom: bottomNavGap + 95, // 네비 위로 띄우기
            child: GestureDetector(
              onTap: () {
                // 현재 위치로 카메라 이동 (더미 좌표)
                if (_mapController != null) {
                  _mapController!.setCenter(LatLng(37.611846, 126.834059));
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

          CategoryBottomSheet(
            items: categoryItems,
            controller: _sheetController,
            onCategoryTap: _mockSearchByCategory,
          ),

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
