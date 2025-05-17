import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
                        SizedBox(height: 8),
                        Text(
                          '세상 밖으로 한 발짝',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(height: 180),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed:
                                () => ref
                                    .read(authProvider.notifier)
                                    .login('kakao'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFDDC3F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 14,
                              ),
                            ),
                            icon: SvgPicture.asset(
                              'assets/logo/kakao.svg',
                              width: 26,
                              height: 24,
                            ),
                            label: Text(
                              '카카오로 시작하기',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton.icon(
                            onPressed:
                                () => ref
                                    .read(authProvider.notifier)
                                    .login('google'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Color(0xFFDEDEDE),
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 14,
                              ),
                            ),
                            icon: SvgPicture.asset(
                              'assets/logo/google.svg',
                              width: 26,
                              height: 26,
                            ),
                            label: Text(
                              '구글로 시작하기',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                                color: Color(0xFF000000),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        TextButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            '문의하기',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF000000),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(height: 60),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
