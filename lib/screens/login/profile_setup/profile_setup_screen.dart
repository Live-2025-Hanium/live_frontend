import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/nickname_field.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/profile_image_picker.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/gender_selector.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/birthday_selector.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/job_selector.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ValueNotifier<bool> _isFormValidNotifier = ValueNotifier(false);

  @override
  void dispose() {
    _isFormValidNotifier.dispose();
    super.dispose();
  }

  void updateButtonState() {
    // *** 여기가 핵심 수정사항입니다! ***
    // UI를 다시 그리게 만드는 .validate() 메소드 대신,
    // 현재 유효성 상태 값만 가져오는 .isValid 속성을 사용합니다.
    _isFormValidNotifier.value = _formKey.currentState?.isValid ?? false;
  }

  void profileSetupSubmit() {
    // '확인' 버튼을 눌렀을 때처럼, 최종 제출 시점에는 saveAndValidate()를 사용합니다.
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;
    if (!isValid) return;

    final data = _formKey.currentState!.value;
    final payload = {
      'nickname': data['nickname'],
      'gender': data['gender'],
      'birthDate':
          '${data['year']}-${data['month'].toString().padLeft(2, '0')}-${data['day'].toString().padLeft(2, '0')}',
      'job': data['job'],
    };
    // TODO: API 호출
    print('전송할 payload: $payload');
    context.pushNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: FormBuilder(
            key: _formKey,
            onChanged: updateButtonState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ProfileImagePicker(),
                const Gap(16),
                const NicknameField(),
                const Gap(28),
                const GenderSelector(),
                const Gap(20),
                const BirthdaySelector(),
                const Gap(20),
                const JobSelector(),
                const Gap(30),
                ValueListenableBuilder<bool>(
                  valueListenable: _isFormValidNotifier,
                  builder: (context, isFormValid, child) {
                    return SaeipButton(
                      text: '확인',
                      onPressed: profileSetupSubmit,
                      disabled: !isFormValid,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
