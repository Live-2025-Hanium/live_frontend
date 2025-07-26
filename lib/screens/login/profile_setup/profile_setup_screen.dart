import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/nickname_field.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/profile_image_picker.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/gender_selector.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/birthday_selector.dart';
import 'package:live_frontend/screens/login/profile_setup/widgets/job_selector.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:gap/gap.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool allResponded = false;

  void updateButtonState() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => allResponded = isValid);
  }

  void profileSetupSubmit() {
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;
    if (!isValid) return;

    final data = _formKey.currentState!.value;
    final payload = {
      'nickname': data['nickname'],
      'gender': data['gender'],
      'birthDate': '${data['year']}-${data['month'].toString().padLeft(2,'0')}-${data['day'].toString().padLeft(2,'0')}',
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
                const Gap(20),
                const GenderSelector(),
                const Gap(20),
                const BirthdaySelector(),
                const Gap(20),
                const JobSelector(),
                const Gap(30),
                SaeipButton(
                  text: '확인',
                  onPressed: profileSetupSubmit,
                  disabled: !allResponded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
