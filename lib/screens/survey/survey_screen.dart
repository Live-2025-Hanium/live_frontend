import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:go_router/go_router.dart';

class SurveyScreen extends ConsumerStatefulWidget {
  final String page;
  const SurveyScreen({super.key, this.page = '0'});

  @override
  ConsumerState<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends ConsumerState<SurveyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(lastPage: '/home'),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 0,
          bottom: 40.0,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_buildUserInfoWidget()],
              ),
              SizedBox(
                width: double.infinity,
                child: SaeipButton(
                  text: '다음',
                  onPressed: () {
                    context.push('/forum/detail');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 사용자 님에 대해 알려주세요 위젯
  Widget _buildUserInfoWidget() {
    // 사용자 이름 rivorpod에서 가져오기
    final userName = ref.watch(authProvider).user?.name ?? "사용자";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: userName,
                style: AppTextStyles.subtitleMedium(
                  context,
                  color: AppColors.greenNormal,
                ),
              ),
              TextSpan(
                text: " 님에 대해\n 알려주세요!",
                style: AppTextStyles.subtitleMedium(
                  context,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
