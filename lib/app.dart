import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'routers/app_router.dart';

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
}
