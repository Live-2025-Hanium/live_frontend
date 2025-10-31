import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/screens/404/not_found_screen.dart';
import 'package:live_frontend/screens/forum/forum_screen.dart';
import 'package:live_frontend/screens/home/clover-record/mission_record_screen.dart';
import 'package:live_frontend/screens/home/execute/execute_photo_mission_screen.dart';
import 'package:live_frontend/screens/home/execute/execute_timer_mission_screen.dart';
import 'package:live_frontend/screens/home/execute/execute_visit_mission_screen.dart';
import 'package:live_frontend/screens/home/my-mission-add/my_mission_add_screen.dart';
import 'package:live_frontend/screens/home/my-mission-add/repeat/repeat_screen.dart';
import 'package:live_frontend/screens/map/map_screen.dart';
import 'package:live_frontend/screens/mypage/mypage_screen.dart';
import 'package:live_frontend/screens/root_screen.dart';
import 'package:live_frontend/screens/statistics/statistics_screen.dart';
import 'package:live_frontend/screens/statistics/weekly-report/weekly_report_screen.dart';
import 'package:live_frontend/screens/survey/survey_screen.dart';
import 'package:live_frontend/screens/login/terms/terms_detail/terms_detail_screen.dart';
import 'package:live_frontend/screens/login/terms/terms_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/profile_setup/profile_setup_screen.dart';
import '../screens/home/home_screen.dart';
import '../providers/auth_provider.dart';
import 'package:live_frontend/screens/forum/forum_post_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      // redirect 내부에서 최신 인증 상태를 직접 읽어옵니다.
      final authStatus = ref.watch(authProvider);
      final isLoggedIn = authStatus.status == AuthStatus.authenticated;
      final isLoading = authStatus.status == AuthStatus.loading;
      final isOnLoginPage = state.uri.toString() == '/login';

      debugPrint(
        'isLoading: $isLoading, isLoggedIn: $isLoggedIn, isOnLoginPage: $isOnLoginPage',
      );

      // 1. 로딩 중엔 아무것도 리디렉션하지 않음
      if (isLoading) return null;

      // 2. 로그인 안 돼있고 로그인 페이지가 아니면 → 로그인으로
      if (!isLoggedIn && !isOnLoginPage) return '/login';

      // 3. 로그인 돼있는데 로그인 페이지 가려고 하면 → 홈으로
      if (isLoggedIn && isOnLoginPage) {
        debugPrint('✅ 로그인 상태에서 /login 접근 시도, 홈으로 리디렉트');
        debugPrint('isNewUser: ${authStatus.isNewUser}');
        if (authStatus.isNewUser == true) {
          return '/login/terms';
        } else {
          return '/home';
        }
      }

      return null;
    },
    errorBuilder: (context, state) {
      return NotFoundScreen(error: state.error);
    },
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/login'),
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
                  final qp = state.uri.queryParameters;
                  bool? isChecked;
                  if (qp.containsKey('isChecked')) {
                    isChecked = qp['isChecked'] == 'true';
                  }
                  if (isChecked == null && state.extra is bool) {
                    isChecked = state.extra as bool;
                  }
                  return TermsDetailScreen(
                    path: path,
                    isChecked: isChecked ?? false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        builder: (context, state, child) {
          return RootScreen(child: child);
        },
        routes: [
          GoRoute(
            name: 'home',
            path: '/home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                name: 'mission_record',
                path: 'mission_record/:id',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'];
                  final id = idStr != null
                      ? int.tryParse(idStr)
                      : (state.extra as int?);
                  if (id == null) return const NotFoundScreen();
                  return MissionRecordScreen(id: id);
                },
              ),
              GoRoute(
                name: 'timer_mission',
                path: 'execute/timer_mission/:id',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'];
                  final id = idStr != null
                      ? int.tryParse(idStr)
                      : (state.extra as int?);
                  if (id == null) return const NotFoundScreen();
                  return ExecuteTimerMissionScreen(id: id);
                },
              ),
              GoRoute(
                name: 'photo_mission',
                path: 'execute/photo_mission/:id',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'];
                  final id = idStr != null
                      ? int.tryParse(idStr)
                      : (state.extra as int?);
                  if (id == null) return const NotFoundScreen();
                  return ExecutePhotoMissionScreen(id: id);
                },
              ),
              GoRoute(
                name: 'visit_mission',
                path: 'execute/visit_mission/:id',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'];
                  final id = idStr != null
                      ? int.tryParse(idStr)
                      : (state.extra as int?);
                  if (id == null) return const NotFoundScreen();
                  return ExecuteVisitMissionScreen(id: id);
                },
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
                      final qp = state.uri.queryParameters;
                      RepeatDay? initial;
                      if (qp.containsKey('initial')) {
                        final val = qp['initial']!;
                        try {
                          initial = RepeatDay.values.firstWhere(
                            (e) => e.toString().split('.').last == val,
                          );
                        } catch (_) {
                          initial = null;
                        }
                      }
                      if (initial == null && state.extra is RepeatDay) {
                        initial = state.extra as RepeatDay;
                      }
                      return RepeatScreen(initial: initial);
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
            routes: [
              GoRoute(
                path: 'weekly_report',
                name: 'weekly_report',
                builder: (context, state) {
                  Jiffy? referenceDate;
                  MissionType? missionType;

                  final qp = state.uri.queryParameters;
                  if (qp.containsKey('referenceDate')) {
                    referenceDate = Jiffy.parse(qp['referenceDate']!);
                  }
                  if (qp.containsKey('missionType')) {
                    final mtStr = qp['missionType']!;
                    try {
                      missionType = MissionType.values.firstWhere(
                        (e) => e.toString().split('.').last == mtStr,
                      );
                    } catch (_) {
                      missionType = null;
                    }
                  }

                  // Fallback to extra (existing navigation behavior)
                  if (referenceDate == null || missionType == null) {
                    if (state.extra is Map<String, dynamic>) {
                      final args = state.extra as Map<String, dynamic>;
                      referenceDate = args['referenceDate'] as Jiffy?;
                      missionType = args['missionType'] as MissionType?;
                    }
                  }

                  if (referenceDate == null || missionType == null) {
                    return const NotFoundScreen();
                  }

                  return WeeklyReportScreen(
                    referenceDate: referenceDate,
                    missionType: missionType,
                    selectedIndex: int.tryParse(qp['selectedIndex'] ?? '') ?? 0,
                  );
                },
              ),
            ],
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
            routes: [
              GoRoute(
                name: 'forum_post',
                path: 'post/:id',
                builder: (context, state) {
                  final idStr = state.pathParameters['id'];
                  final id = int.tryParse(idStr ?? '');
                  if (id == null) {
                    return const NotFoundScreen();
                  }
                  return ForumPostScreen(postId: id);
                },
              ),
            ],
          ),
          GoRoute(
            name: 'mypage',
            path: '/mypage',
            builder: (context, state) => const MyPageScreen(),
          ),
        ],
      ),
      GoRoute(
        name: 'survey',
        path: '/survey',
        builder: (context, state) => SurveyScreen(),
      ),
    ],
  );
});
