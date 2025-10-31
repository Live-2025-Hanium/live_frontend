import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/core/controllers/profile_controller.dart';
import 'package:live_frontend/core/utils/s3_upload_util.dart';
import 'package:live_frontend/models/profile_model.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/nickname_field.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/profile_image_picker.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/gender_selector.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/birthday_selector.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/job_selector.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _nicknameKey = GlobalKey<NicknameFieldState>();
  final ValueNotifier<bool> _isFormValidNotifier = ValueNotifier(false);
  Uint8List? _pickedImageBytes;
  String? _pickedImageExtension;

  @override
  void dispose() {
    _isFormValidNotifier.dispose();
    super.dispose();
  }

  void updateButtonState() {
    _isFormValidNotifier.value = _formKey.currentState?.isValid ?? false;
  }

  Future<bool> profileSetupSubmit() async {
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;
    if (!isValid) return false;

    final nicknameState = _nicknameKey.currentState;
    if (nicknameState == null || !nicknameState.isNicknameValid) {
      // 닉네임 필드에 직접 에러 메시지 세팅
      _formKey.currentState?.fields['nickname']?.invalidate(
        '닉네임 중복 확인을 완료해주세요.',
      );
      return false;
    }

    final formData = _formKey.currentState!.value;
    String? profileImageUrl;

    debugPrint('✅ 프로필 설정 폼 데이터: $formData');

    try {
      if (_pickedImageBytes != null && _pickedImageExtension != null) {
        profileImageUrl = await uploadImageToS3(
          ref: ref,
          imageBytes: _pickedImageBytes!,
          imageExtension: _pickedImageExtension!,
          domain: 'PROFILE',
        );
      }

      final profileController = ref.read(profileControllerProvider);
      final payload = ProfileUpdatePayloadModel(
        nickname: formData['nickname'] as String,
        gender: (formData['gender'] as Gender).value,
        occupation: (formData['job'] as Occupation).value,
        profileImageUrl: profileImageUrl ?? '',
        birthYear: formData['year'],
        birthMonth: formData['month'],
        birthDay: formData['day'],
      );

      return await profileController.updateProfile(payload);

      // final formData = _formKey.currentState!.value;
      // final saeipUser = SaeipUserModel.fromFormData(formData);
    } catch (e) {
      debugPrint('❌ 네트워크 오류: $e');
    }
    return false;
    // context.pushNamed('survey');
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
                ProfileImagePicker(
                  onImagePicked: (bytes, extension) {
                    setState(() {
                      _pickedImageBytes = bytes;
                      _pickedImageExtension = extension;
                    });
                  },
                ),
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
                      onPressed: () async {
                        final success = await profileSetupSubmit();
                        debugPrint('✅ 프로필 설정 완료: $success');
                        if (success == true) {
                          if (!mounted) return;
                          context.pushNamed('survey');
                        } else {
                          debugPrint('❌ 프로필 설정 실패');
                        }
                      },
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
