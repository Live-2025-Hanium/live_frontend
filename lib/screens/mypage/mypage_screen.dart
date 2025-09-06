import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_frontend/screens/mypage/phone_call_screen.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';
import 'package:url_launcher/url_launcher.dart';

// Future<void> _dial(String raw) async {
//   final digits = raw.replaceAll(RegExp(r'[^0-9+]'), '');
//   final uri = Uri(scheme: 'tel', path: digits);
//   // 외부 앱(전화 앱)으로 강제
//   await launchUrl(uri, mode: LaunchMode.externalApplication);
// }

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(
        title: 'MyPage',
        appBarStyle: AppBarStyle.common,
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/icons/setting.svg', height: 22.h),
            onPressed: () => {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Material(
          // 리플 원하면 Material+InkWell
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (ctx) => SaeipModal(
                  title: '긴급 전화',
                  message: '긴급 전화를 연결할까요?',
                  confirmText: '연결',
                  cancelText: '취소',
                  onCancel: () => Navigator.of(ctx).pop(),
                  onConfirm: () {
                    Navigator.of(ctx, rootNavigator: true).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PhoneCallScreen(),
                      ),
                    );
                  },
                ),
              );
            },
            child: Image.asset(
              'assets/images/mypage_mock.png',
              //fit: BoxFit.fitWidth, // width 지정 X (중요)
              //width: double.infinity,  // ❌ 이 줄 제거
            ),
          ),
        ),
      ),

      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 4),
    );
  }
}
