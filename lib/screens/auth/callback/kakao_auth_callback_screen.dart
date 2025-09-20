import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class KakaoAuthCallbackScreen extends ConsumerStatefulWidget {
  const KakaoAuthCallbackScreen({super.key});

  @override
  ConsumerState<KakaoAuthCallbackScreen> createState() =>
      _KakaoAuthCallbackScreenState();
}

class _KakaoAuthCallbackScreenState
    extends ConsumerState<KakaoAuthCallbackScreen> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      // Use the current browser URL (contains code param) to perform backend login
      final uri = Uri.base.toString();
      // Trigger the login flow after the current frame to avoid modifying providers
      // while the widget tree is building.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(authProvider.notifier).loginWithKakaoWeb(uri);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.status == AuthStatus.authenticated) {
      // navigate back to root (or a named route); replace to avoid back stack
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.goNamed('terms');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authState.status == AuthStatus.error) {
      return Scaffold(
        body: Center(child: Text('로그인 실패: ${authState.error ?? '알 수 없는 오류'}')),
      );
    }

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
