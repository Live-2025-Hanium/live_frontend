import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_frontend/providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child:
                isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/logo/logo.svg',
                          width: 156,
                          height: 80,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '세상 밖으로 한 발짝',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 180),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed:
                                () => ref
                                    .read(authProvider.notifier)
                                    .login('kakao'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFDDC3F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 14,
                              ),
                            ),
                            icon: SvgPicture.asset(
                              'assets/logo/kakao.svg',
                              width: 26,
                              height: 24,
                            ),
                            label: const Text(
                              '카카오로 시작하기',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed:
                                () => ref
                                    .read(authProvider.notifier)
                                    .login('google'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color(0xFFDEDEDE),
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 14,
                              ),
                            ),
                            icon: SvgPicture.asset(
                              'assets/logo/google.svg',
                              width: 26,
                              height: 26,
                            ),
                            label: const Text(
                              '구글로 시작하기',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            '문의하기',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF000000),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
