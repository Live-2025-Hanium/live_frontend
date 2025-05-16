import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/login/login_screen.dart';
import '../screens/home.dart';
import '../providers/auth_provider.dart';

// 라우터 새로고침 트리거
final routerRefreshProvider = ChangeNotifierProvider((ref) {
  return _RouterRefreshNotifier(ref.watch(authProvider.notifier));
});

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(StateNotifier authNotifier) {
    authNotifier.addListener((_) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: ref.watch(routerRefreshProvider),
    redirect: (context, state) {
      final loggingIn = state.uri.toString() == '/login';

      if (!authState.isLoggedIn && !loggingIn) {
        return '/login';
      }
      if (authState.isLoggedIn && loggingIn) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
  );
});
