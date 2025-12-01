import 'package:flutter/material.dart';
import 'package:live_frontend/screens/map/widgets/map_appbar.dart';
import 'package:live_frontend/widgets/platform_kakao_map.dart';

class MapSearchResultScreen extends StatefulWidget {
  final TextEditingController externalController;
  final String hintText;

  const MapSearchResultScreen({
    super.key,
    required this.externalController,
    required this.hintText,
  });

  @override
  State<MapSearchResultScreen> createState() => _MapSearchResultScreenState();
}

class _MapSearchResultScreenState extends State<MapSearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapAppBar(
        externalController: widget.externalController,
        hintText: widget.hintText,
      ),
      body: PlatformKakaoMap(),
    );
  }
}
