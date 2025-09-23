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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // restore auth session after provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).restoreSession();
    });
  }

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
              trackOutlineColor: WidgetStatePropertyAll(AppColors.blackBlack2),
            ),
            colorScheme: saeipColorScheme,
            useMaterial3: true,
          ),
          // ⬇️ 여기서 '웹에서만' 전체 레이아웃에 max-width 적용
          builder: (context, child) {
            final content = child ?? const SizedBox.shrink();

            if (!kIsWeb) return content; // 모바일/데스크톱 앱 = 그대로

            final w = MediaQuery.of(context).size.width;

            // 폭이 좁을 때는 그냥 가득 차되, 약간의 좌우 여백만
            if (w < kNarrowWidthCutoff) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: kGutter),
                child: content,
              );
            }

            // 데스크톱급 폭에서는 중앙 정렬 + 최대 너비 제한
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kMaxWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kGutter),
                  child: content,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
