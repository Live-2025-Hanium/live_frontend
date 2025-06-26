import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'routers/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    final saeipColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.greenNormal,
      onPrimary: Colors.white,
      primaryContainer: AppColors.greenLight, // primary.light
      secondary: AppColors.pinkNormal,
      onSecondary: Colors.white,
      surface: Colors.white, // background.paper
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
            checkboxTheme: CheckboxThemeData(
              side: const BorderSide(color: AppColors.greenNormal),
            ),
            colorScheme: saeipColorScheme,
            useMaterial3: true,
          ),
        );
      },
    );
  }
}
