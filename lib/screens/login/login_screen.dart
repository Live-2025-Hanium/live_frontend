import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'widgets/login_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        if (next.isNewUser == true) {
          context.go('/login/terms');
        } else {
          context.go('/home');
        }
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/logo/logo.svg',
                            width: 204,
                            height: 56,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '세상 밖으로 한 발짝',
                            style: AppTextStyles.titleSemibold(
                              context,
                              color: AppColors.greenNormal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    LoginButton(
                      onPressed: () {
                        ref.read(authProvider.notifier).loginWithKakao();
                      },
                      label: '카카오로 시작하기',
                      icon: SvgPicture.asset(
                        'assets/logo/kakao.svg',
                        width: 24,
                        height: 24,
                      ),
                      backgroundColor: const Color(0xFFFDDC3F),
                    ),
                    SizedBox(height: 12),
                    LoginButton(
                      onPressed: () {
                        ref.read(authProvider.notifier).loginWithGoogle();
                      },
                      label: 'Google로 시작하기',
                      icon: SvgPicture.asset(
                        'assets/logo/google.svg',
                        width: 26,
                        height: 26,
                      ),
                      backgroundColor: const Color(0xFFFFFFFF),
                      borderSide: const BorderSide(
                        color: AppColors.blackBlack2,
                        width: 1,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    TextButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        '문의하기',
                        style: AppTextStyles.smallMedium(
                          context,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
