import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'dart:io';

class SaeipNavigationBar extends StatefulWidget {
  final int initialIndex;

  const SaeipNavigationBar({super.key, this.initialIndex = 0});

  @override
  State<SaeipNavigationBar> createState() => _SaeipNavigationBarState();
}

class _SaeipNavigationBarState extends State<SaeipNavigationBar> {
  late int _currentIndex;

  final bool isIOS = Platform.isIOS;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> routes = [
      'home',
      'statistics',
      'map',
      'forum',
      'mypage',
    ];

    void onTap(int index) {
      setState(() {
        _currentIndex = index;
      });
      context.goNamed(routes[index]);
    }

    TextStyle labelStyle = AppTextStyles.tinyMedium(
      context,
      color: AppColors.blackBlack3,
    );

    TextStyle selectedLabelStyle = AppTextStyles.tinyMedium(
      context,
      color: Colors.black,
    );

    ColorFilter iconColorFilter = ColorFilter.mode(
      AppColors.blackBlack3,
      BlendMode.srcIn,
    );

    ColorFilter selectedIconColorFilter = ColorFilter.mode(
      Colors.black,
      BlendMode.srcIn,
    );

    return NavigationBar(
      height: isIOS ? 84.0 : 80.0,
      backgroundColor: Colors.white,
      labelPadding: const EdgeInsets.symmetric(horizontal: 2.0),
      onDestinationSelected: onTap,
      indicatorColor: Colors.white,
      selectedIndex: _currentIndex,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return selectedLabelStyle;
        }
        return labelStyle;
      }),

      destinations: [
        NavigationDestination(
          selectedIcon: SvgPicture.asset(
            'assets/icons/home.svg',
            colorFilter: selectedIconColorFilter,
          ),
          icon: SvgPicture.asset(
            'assets/icons/home.svg',
            colorFilter: iconColorFilter,
          ),
          label: '홈',
        ),
        NavigationDestination(
          selectedIcon: SvgPicture.asset(
            'assets/icons/statistics.svg',
            colorFilter: selectedIconColorFilter,
          ),
          icon: SvgPicture.asset(
            'assets/icons/statistics.svg',
            colorFilter: iconColorFilter,
          ),
          label: '통계',
        ),
        NavigationDestination(
          selectedIcon: SvgPicture.asset(
            'assets/icons/map.svg',
            colorFilter: selectedIconColorFilter,
          ),
          icon: SvgPicture.asset(
            'assets/icons/map.svg',
            colorFilter: iconColorFilter,
          ),
          label: '지도',
        ),
        NavigationDestination(
          selectedIcon: SvgPicture.asset(
            'assets/icons/forum.svg',
            colorFilter: selectedIconColorFilter,
          ),
          icon: SvgPicture.asset(
            'assets/icons/forum.svg',
            colorFilter: iconColorFilter,
          ),
          label: '게시판',
        ),
        NavigationDestination(
          selectedIcon: SvgPicture.asset(
            'assets/icons/person.svg',
            colorFilter: selectedIconColorFilter,
          ),
          icon: SvgPicture.asset(
            'assets/icons/person.svg',
            colorFilter: iconColorFilter,
          ),
          label: '마이페이지',
        ),
      ],
    );
  }
}
