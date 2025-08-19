import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';
import 'package:go_router/go_router.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: 'My Page'),
      body: Center(
        child: SaeipButton(
          text: '마이미션 추가',
          onPressed: () => context.pushNamed('my_mission_add'),
        ),
      ),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 4),
    );
  }
}
