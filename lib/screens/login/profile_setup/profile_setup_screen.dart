import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/models/saeip_user_model.dart';
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
  final _nicknameKey = GlobalKey<NicknameFieldState>();
  final ValueNotifier<bool> _isFormValidNotifier = ValueNotifier(false);

  @override
  void dispose() {
    _isFormValidNotifier.dispose();
    super.dispose();
  }

  void updateButtonState() {
    _isFormValidNotifier.value = _formKey.currentState?.isValid ?? false;
  }

  Future<void> profileSetupSubmit() async {
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;
    if (!isValid) return;

    final nicknameState = _nicknameKey.currentState;
    if (nicknameState == null || !nicknameState.isNicknameValid) {
      // 닉네임 필드에 직접 에러 메시지 세팅
      _formKey.currentState?.fields['nickname']?.invalidate(
        '닉네임 중복 확인을 완료해주세요.',
      );
      return;
    }

    // final formData = _formKey.currentState!.value;
    // final saeipUser = SaeipUserModel.fromFormData(formData);

    try {
      context.pushNamed('survey');
    } catch (e) {
      debugPrint('❌ 네트워크 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FormBuilder(
            key: _formKey,
            onChanged: updateButtonState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ProfileImagePicker(),
                Gap(16.h),
                NicknameField(key: _nicknameKey),
                Gap(28.h),
                const GenderSelector(),
                Gap(28.h),
                const BirthdaySelector(),
                Gap(28.h),
                const JobSelector(),
                Gap(20.h),
                ValueListenableBuilder<bool>(
                  valueListenable: _isFormValidNotifier,
                  builder: (context, isFormValid, _) {
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
