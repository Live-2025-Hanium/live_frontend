import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/screens/404/not_found_screen.dart';
import 'package:live_frontend/screens/forum/forum_screen.dart';
import 'package:live_frontend/screens/home/clover-record/mission_record_screen.dart';
import 'package:live_frontend/screens/home/execute/execute_photo_mission_screen.dart';
import 'package:live_frontend/screens/home/execute/execute_timer_mission_screen.dart';
import 'package:live_frontend/screens/home/my-mission-add/my_mission_add_screen.dart';
import 'package:live_frontend/screens/home/my-mission-add/repeat/repeat_screen.dart';
import 'package:live_frontend/screens/map/map_screen.dart';
import 'package:live_frontend/screens/mypage/mypage_screen.dart';
import 'package:live_frontend/screens/statistics/statistics_screen.dart';
import 'package:live_frontend/screens/survey/survey_screen.dart';
import 'package:live_frontend/screens/login/terms/terms_detail/terms_detail_screen.dart';
import 'package:live_frontend/screens/login/terms/terms_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/profile_setup/profile_setup_screen.dart';
import '../screens/home/home_screen.dart';
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

      // 3. 로그인 돼있는데 로그인 페이지 가려고 하면 → 약관 동의 화면 (임시처리)
      if (isLoggedIn && isOnLoginPage) return '/login/terms';

      return null;
    },
    errorBuilder: (context, state) {
      return NotFoundScreen(error: state.error);
    },
    routes: [
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
        routes: [
          GoRoute(
            name: 'profile_setup',
            path: 'profile_setup',
            builder: (context, state) => const ProfileSetupScreen(),
          ),
          GoRoute(
            name: 'terms',
            path: 'terms',
            builder: (context, state) {
              return TermsScreen();
            },
            routes: [
              GoRoute(
                name: 'terms_detail',
                path: ':file_path',
                builder: (context, state) {
                  final path = state.pathParameters['file_path']!;
                  final data = state.extra as bool?;
                  return TermsDetailScreen(
                    path: path,
                    isChecked: data ?? false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: 'home',
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            name: 'mission_record',
            path: 'mission_record',
            builder: (context, state) => const MissionRecordScreen(),
          ),
          GoRoute(
            name: 'timer_mission',
            path: 'execute/timer_mission',
            builder: (context, state) =>
                ExecuteTimerMissionScreen(id: state.extra as int),
          ),
          GoRoute(
            name: 'photo_mission',
            path: 'execute/photo_mission',
            builder: (context, state) =>
                ExecutePhotoMissionScreen(id: state.extra as int),
          ),
          GoRoute(
            name: 'my_mission_add',
            path: 'my_mission_add',
            builder: (context, state) {
              return MyMissionAddScreen();
            },
            routes: [
              GoRoute(
                path: 'repeat',
                name: 'repeat',
                builder: (context, state) {
                  return RepeatScreen(initial: state.extra as RepeatDay?);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: 'statistics',
        path: '/statistics',
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        name: 'map',
        path: '/map',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        name: 'forum',
        path: '/forum',
        builder: (context, state) => const ForumScreen(),
      ),
      GoRoute(
        name: 'mypage',
        path: '/mypage',
        builder: (context, state) => const MyPageScreen(),
      ),

      GoRoute(
        name: 'survey',
        path: '/survey',
        builder: (context, state) => SurveyScreen(),
      ),
    ],
  );
});
