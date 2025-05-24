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
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final isLoading = authState.status == AuthStatus.loading;
      final isOnLoginPage = state.uri.toString() == '/login';

      // 1. 로딩 중엔 아무것도 리디렉션하지 않음
      if (isLoading) return null;

      // 2. 로그인 안 돼있고 로그인 페이지가 아니면 → 로그인으로
      if (!isLoggedIn && !isOnLoginPage) return '/login';

      // 3. 로그인 돼있는데 로그인 페이지 가려고 하면 → 홈으로
      if (isLoggedIn && isOnLoginPage) return '/home';

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
  );
});
