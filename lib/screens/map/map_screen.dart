import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/utilities/location_util.dart';
import 'package:live_frontend/widgets/platform_kakao_map.dart';
import 'package:live_frontend/screens/map/widgets/map_bottom_sheet.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 현재 위도, 경도 상태 변수
  double? _currentLatitude;
  double? _currentLongitude;
  bool _isLoading = true;
  bool _isMapInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchLocationAndUpdateState();
  }

  Future<void> _fetchLocationAndUpdateState() async {
    debugPrint('MapScreen: start fetching location');
    try {
      final location = await getCurrentLocation();
      debugPrint('MapScreen: location result => $location');
      if (mounted) {
        setState(() {
          if (location != null) {
            _currentLatitude = location.latitude;
            _currentLongitude = location.longitude;
          }
          _isLoading = false;
          _isMapInitialized = true;
        });
      }

      if (location == null && mounted) {
        // Provide clear feedback for simulator users or permission failures
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('위치 정보를 가져올 수 없습니다'),
            content: const Text(
              '시뮬레이터에서 위치가 설정되어 있지 않거나 권한이 거부되었습니다.\n'
              '시뮬레이터 메뉴(Debug → Location)에서 위치를 설정하거나,\n'
              '실제 기기에서 권한을 확인해주세요.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('MapScreen: exception while fetching location: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isMapInitialized = true; // Also mark as initialized on error
        });
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('오류'),
            content: Text('위치 정보를 가져오는 중 오류가 발생했습니다: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _handleLocatePressed() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }
    _fetchLocationAndUpdateState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final String hintText = '장소, 주소 검색';
    return Stack(
      children: [
        if (!_isMapInitialized || _isLoading)
          const Center(child: CircularProgressIndicator())
        else
          PlatformKakaoMap(
            centerLat: _currentLatitude,
            centerLng: _currentLongitude,
          ),
        Positioned(
          top: 8,
          left: 12,
          right: 12,
          child: SafeArea(
            child: SaeipSearchBar(
              controller: controller,
              onSubmit: (String query) {
                // 검색어 제출 시 동작 (여기서는 아무 동작도 하지 않음)
              },
              logoSvgAsset: 'assets/icons/clover.svg',
              hintText: hintText,
              openDetail: () {
                context.pushNamed(
                  'map_search',
                  extra: {
                    'externalController': controller,
                    'hintText': hintText,
                  },
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: MapBottomSheet(
            showCategories: true,
            onLocatePressed: _handleLocatePressed,
          ),
        ),
        if (_isLoading || !_isMapInitialized)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }
}
