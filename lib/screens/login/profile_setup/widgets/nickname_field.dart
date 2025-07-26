import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:live_frontend/theme/app_colors.dart';

class NicknameField extends StatelessWidget {
  const NicknameField({super.key});

  /// 모의 중복 확인 함수 (API 호출 연동 필요)
  Future<bool> _checkNickname(String nickname) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return nickname != '일이삼사오육칠팔구십';
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      onChanged: (val) {
        final formState = FormBuilder.of(context);
        final field = formState?.fields['nickname'];

        // 오류 메시지 제거
        if (field?.errorText != null) {
          field?.validate();
        }
      },
      name: 'nickname',
      maxLength: 10,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: '닉네임',
        suffixIcon: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                final formState = FormBuilder.of(context);
                final nicknameField = formState?.fields['nickname'];
                final nickname = nicknameField?.value?.trim() ?? '';

                // 👉 유효성 검사를 먼저 수행 (빈 문자열, 길이 등)
                final isValid = nicknameField?.validate() ?? false;
                if (!isValid || nickname.isEmpty) return;

                // 👉 실제 중복 확인 요청
                final isAvailable = await _checkNickname(nickname);

                if (!isAvailable) {
                  // 중복일 경우 에러 메시지로 invalidate
                  nicknameField?.invalidate('이미 사용 중인 닉네임입니다.');
                } else {
                  // 사용 가능할 경우 다시 유효화 + 메시지 출력
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('사용 가능한 닉네임입니다.')),
                  );
                }
              },
              child: const Text('중복 확인'),
            );
          },
        ),
      ),
      validator: (val) {
        final v = val?.trim() ?? '';
        if (v.isEmpty) return '닉네임을 입력해주세요.';
        if (v.length > 10) return '10자 이하로 입력해주세요.';
        return null;
      },
    );
  }
}
