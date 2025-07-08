import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:gap/gap.dart';

class NotFoundScreen extends StatelessWidget {
  final GoException? error;

  const NotFoundScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: '페이지를 찾을 수 없음'),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/404.svg'),
              const Gap(38),
              Text(
                '페이지를 찾을 수 없어요.',
                style: AppTextStyles.titleMedium(context, color: Colors.black),
              ),
              const Gap(8),
              Text(
                '페이지가 이동되었거나 삭제되었을 수 있어요.',
                style: AppTextStyles.bodyRegular(
                  context,
                  color: AppColors.blackBlack4,
                ),
              ),
              const MaxGap(240),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed('home');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppColors.greenDark,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(
                  '홈으로 돌아가기',
                  style: AppTextStyles.bodySemibold(
                    context,
                    color: Colors.white,
                  ),
                ),
              ),
              const MaxGap(40),
            ],
          ),
        ),
      ),
    );
  }
}
