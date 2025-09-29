import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'routers/app_router.dart';
import 'package:live_frontend/providers/auth_provider.dart';

const kMaxWidth = 600.0; // 웹 본문 최대 너비
const kGutter = 24.0; // 좌우 여백
const kNarrowWidthCutoff = 900.0; // 좁은 폭(태블릿/모바일 웹) 기준
const kMobileDesignWidth = 360.0; // 모바일 기준 디자인 너비

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    final saeipColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.greenNormal,
      onPrimary: Colors.white,
      primaryContainer: AppColors.greenLight,
      secondary: AppColors.pinkNormal,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
      error: AppColors.errorError3,
      onError: Colors.white,
    );

    // 웹이 아닌 경우 기존 방식 사용
    if (!kIsWeb) {
      return ScreenUtilInit(
        designSize: const Size(360, 780),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            routerConfig: router,
            title: 'SaeIp',
            theme: ThemeData(
              checkboxTheme: const CheckboxThemeData(
                side: BorderSide(color: AppColors.greenNormal),
              ),
              switchTheme: SwitchThemeData(
                trackOutlineColor: WidgetStatePropertyAll(
                  AppColors.blackBlack2,
                ),
              ),
              colorScheme: saeipColorScheme,
              useMaterial3: true,
            ),
          );
        },
      );
    }

    // 웹인 경우 레이아웃 제한 후 ScreenUtilInit 적용
    return MaterialApp.router(
      routerConfig: router,
      title: 'SaeIp',
      theme: ThemeData(
        checkboxTheme: const CheckboxThemeData(
          side: BorderSide(color: AppColors.greenNormal),
        ),
        switchTheme: SwitchThemeData(
          trackOutlineColor: WidgetStatePropertyAll(AppColors.blackBlack2),
        ),
        colorScheme: saeipColorScheme,
        useMaterial3: true,
      ),
      builder: (context, child) {
        return WebLayoutWrapper(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

class WebLayoutWrapper extends StatelessWidget {
  final Widget child;

  const WebLayoutWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        // 실제 콘텐츠가 사용할 너비 계산
        double contentWidth;
        if (screenWidth < kNarrowWidthCutoff) {
          contentWidth = screenWidth - (kGutter * 2);
        } else {
          contentWidth = kMaxWidth - (kGutter * 2);
        }

        // 콘텐츠 너비 기준으로 디자인 사이즈 조정
        // 원래 디자인(360px) 대비 실제 사용 가능한 너비의 비율을 계산
        final designSize = Size(contentWidth, 780);

        Widget constrainedChild;

        if (screenWidth < kNarrowWidthCutoff) {
          // 좁은 화면: 양쪽에 gutter만 적용
          constrainedChild = Padding(
            padding: const EdgeInsets.symmetric(horizontal: kGutter),
            child: child,
          );
        } else {
          // 넓은 화면: 중앙 정렬 + 최대 너비 제한
          constrainedChild = Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kMaxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kGutter),
                child: child,
              ),
            ),
          );
        }

        // 제약된 레이아웃 내에서 ScreenUtilInit 적용
        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, screenUtilChild) {
            return constrainedChild;
          },
        );
      },
    );
  }
}

// 더 정교한 제어를 원한다면 이 방법도 사용 가능
class ResponsiveScreenUtilWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveScreenUtilWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        // 실제 사용 가능한 콘텐츠 너비
        double effectiveWidth;
        if (screenWidth < kNarrowWidthCutoff) {
          effectiveWidth = screenWidth - (kGutter * 2);
        } else {
          effectiveWidth = kMaxWidth - (kGutter * 2);
        }

        // 비율 기반으로 새로운 디자인 사이즈 계산
        // 360px를 기준으로 했다면, 실제 너비에 맞게 스케일링
        final scale = effectiveWidth / kMobileDesignWidth;
        final scaledDesignSize = Size(
          effectiveWidth,
          780 * scale, // 높이도 비례해서 조정
        );

        return ScreenUtilInit(
          designSize: scaledDesignSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, _) => child,
        );
      },
    );
  }
}
