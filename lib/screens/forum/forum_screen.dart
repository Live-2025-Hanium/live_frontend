import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: SaeipAppBar(title: 'Forum'),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        height: double.infinity,
      ),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 3),
    );
  }
}
