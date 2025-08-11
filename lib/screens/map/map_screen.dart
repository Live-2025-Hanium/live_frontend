import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';
import 'package:go_router/go_router.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: 'Map'),
      body: Center(
        child: SaeipButton(
          text: '미션 기록',
          onPressed: () {
            context.pushNamed('mission_record');
          },
        ),
      ),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 2),
    );
  }
}
