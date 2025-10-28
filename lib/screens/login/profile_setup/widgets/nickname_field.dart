import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/core/controllers/profile_controller.dart';
import 'package:live_frontend/models/profile_model.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/utils/show_saeip_toast.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:live_frontend/widgets/saeip_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NicknameField extends ConsumerStatefulWidget {
  const NicknameField({super.key});

  @override
  NicknameFieldState createState() => NicknameFieldState();
}

class NicknameFieldState extends ConsumerState<NicknameField> {
  late final TextEditingController _controller;

  // 중복 확인 버튼 클릭 여부
  bool _isDuplicateChecked = false;

  // 중복 확인 성공 여부
  bool _isAvailable = false;

  // 외부에서 접근 가능한 getter
  bool get isNicknameValid => _isDuplicateChecked && _isAvailable;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleDuplicateCheck() async {
    final formState = FormBuilder.of(context);
    final nicknameField = formState?.fields['nickname'];

    // 1차 유효성 검사
    final isValid = nicknameField?.validate() ?? false;
    if (!isValid) return;

    final nickname = nicknameField?.value?.trim() ?? '';
    final nicknameCheckResponse = await ref
        .read(profileControllerProvider)
        .checkNicknameDuplicated(nickname);

    if (!mounted) return;

    setState(() {
      _isDuplicateChecked = true;
      _isAvailable = nicknameCheckResponse.available;
    });

    if (!nicknameCheckResponse.available) {
      nicknameField?.invalidate(nicknameCheckResponse.message);
      await showDialog<void>(
        context: context,
        builder: (ctx) => SaeipModal(
          message: nicknameCheckResponse.message,
          confirmText: '확인',
          confirmBackgroundColor: AppColors.errorError3,
          onConfirm: () {
            Navigator.of(ctx).pop();
          },
        ),
      );
    } else {
      nicknameField?.setValue(nickname);
      SaeipToastController.showMessage(context, '사용 가능한 닉네임입니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: 'nickname',
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: '닉네임을 입력해주세요.'),
      ]),
      builder: (field) {
        final hasError = field.hasError;
        final errorText = field.errorText;
        const errorColor = AppColors.errorError3;
        final labelColor = hasError ? errorColor : AppColors.greenNormal;

        if (_controller.text != field.value) {
          _controller.text = field.value ?? '';
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 라벨 + 에러 메시지
            Row(
              children: [
                Text(
                  '닉네임',
                  style: AppTextStyles.bodyMedium(context, color: labelColor),
                ),
                if (hasError) ...[
                  const Gap(8),
                  Expanded(
                    child: Text(
                      errorText ?? '',
                      style: AppTextStyles.smallMedium(
                        context,
                        color: errorColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const Gap(4),

            // 입력 필드 + 버튼
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    cursorColor: AppColors.blackBlack4,
                    maxLength: 10,
                    onChanged: (value) {
                      field.didChange(value);

                      // 닉네임이 변경되면 중복확인 상태 초기화
                      if (_isDuplicateChecked || _isAvailable) {
                        setState(() {
                          _isDuplicateChecked = false;
                          _isAvailable = false;
                        });
                      }

                      if (field.errorText == '이미 사용 중인 닉네임입니다.') {
                        field.validate();
                      }
                    },
                    decoration: InputDecoration(
                      counterText: '',
                      errorStyle: const TextStyle(fontSize: 0, height: 0),
                      helperText: ' ',
                      helperStyle: const TextStyle(fontSize: 0, height: 0),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blackBlack1),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blackBlack1),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: errorColor),
                      ),
                      focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: errorColor),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text(
                          '${field.value?.length ?? 0}/10',
                          style: AppTextStyles.smallMedium(
                            context,
                            color: AppColors.blackBlack4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Gap(8),
                SizedBox(
                  width: 76,
                  height: 40,
                  child: SaeipButton.outlined(
                    text: '중복 확인',
                    onPressed: _handleDuplicateCheck,
                    outlineColor: labelColor,
                    textStyle: AppTextStyles.smallMedium(
                      context,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
