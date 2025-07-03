import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: 'My Page'),
      body: const Center(child: Text('마이페이지')),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 4),
    );
  }
}
