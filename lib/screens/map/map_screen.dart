import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: KakaoMap(),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 2),
    );
  }
}
