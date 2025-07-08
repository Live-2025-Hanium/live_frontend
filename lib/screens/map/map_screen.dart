import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: 'Map'),
      body: const Center(child: Text('지도 화면')),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 2),
    );
  }
}
