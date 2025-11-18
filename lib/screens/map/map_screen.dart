import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: KakaoMap());
  }
}
