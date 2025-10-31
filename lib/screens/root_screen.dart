import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';

class RootScreen extends StatelessWidget {
  final Widget child;

  const RootScreen({super.key, required this.child});

  // 현재 경로를 기반으로 선택된 네비게이션 바 인덱스를 계산합니다.
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/statistics')) return 1;
    if (location.startsWith('/map')) return 2;
    if (location.startsWith('/forum')) return 3;
    if (location.startsWith('/mypage')) return 4;
    return 0;
  }

  // 현재 경로에 따라 AppBar의 제목을 결정합니다.
  String _getAppBarTitle(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 'Home';
    if (location.startsWith('/statistics')) return '분석';
    if (location.startsWith('/map')) return '지도';
    if (location.startsWith('/forum')) return '게시판';
    if (location.startsWith('/mypage')) return '마이페이지';
    return ''; // 기본값
  }

  // 특정 경로에서만 AppBar를 보여줍니다.
  bool _shouldShowAppBar(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/' ||
        location == '/home' ||
        location == '/statistics' ||
        location == '/forum' ||
        location == '/mypage') {
      return true;
    }
    return false;
  }

  // 특정 경로에서만 bottomNavigationBar를 보여줍니다.
  bool _shouldShowBottomNavigationBar(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/' ||
        location == '/home' ||
        location == '/statistics' ||
        location == '/map' ||
        location == '/forum' ||
        location == '/mypage') {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _shouldShowAppBar(context)
          ? SaeipAppBar(
              title: _getAppBarTitle(context),
              appBarStyle: AppBarStyle.common,
            )
          : null,
      body: child,
      bottomNavigationBar: _shouldShowBottomNavigationBar(context)
          ? SaeipNavigationBar(initialIndex: _calculateSelectedIndex(context))
          : null,
    );
  }
}
