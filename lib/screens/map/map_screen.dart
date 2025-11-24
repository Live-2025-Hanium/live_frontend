import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/platform_kakao_map.dart';
import 'package:live_frontend/screens/map/widget/map_bottom_sheet.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final String hintText = '장소, 주소 검색';
    return Stack(
      children: [
        PlatformKakaoMap(centerLat: 37.5, centerLng: 127.0),
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
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: MapBottomSheet(showCategories: true),
        ),
      ],
    );
  }
}
