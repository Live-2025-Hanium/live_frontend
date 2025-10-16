import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/controllers/auth_controller.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: SaeipAppBar(title: 'My Page'),
      body: Center(
        child: TextButton(
          onPressed: () {
            final authController = ref.read(authProvider.notifier);
            authController.logout();
          },
          child: const Text('Log Out'),
        ),
      ),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 4),
    );
  }
}
