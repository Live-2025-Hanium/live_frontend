import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/platform_kakao_map.dart';
import 'package:live_frontend/screens/map/widget/map_bottom_sheet.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlatformKakaoMap(centerLat: 37.5, centerLng: 127.0),
        Positioned(bottom: 0, left: 0, right: 0, child: MapBottomSheet()),
      ],
    );
  }
}
