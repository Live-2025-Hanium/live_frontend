import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: 'Home'),
      body: Center(child: const Text('Welcome to the Home Screen!')),
    );
  }
}
