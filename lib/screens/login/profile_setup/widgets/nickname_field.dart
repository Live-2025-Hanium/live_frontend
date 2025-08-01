import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/utils/show_saeip_toast.dart';
import 'package:live_frontend/widgets/utils/show_saeip_modal.dart';

class NicknameField extends StatefulWidget {
  const NicknameField({super.key});

  @override
  State<NicknameField> createState() => _NicknameFieldState();
}

class _NicknameFieldState extends State<NicknameField> {
  late final TextEditingController _controller;

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

  Future<bool> _checkNickname(String nickname) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return nickname != '일이삼사오육칠팔구십';
  }

  Future<void> _handleDuplicateCheck() async {
    final formState = FormBuilder.of(context);
    final nicknameField = formState?.fields['nickname'];

    // 1차 유효성 검사 -- 미통과시 서버로 요청하지 않음
    final isValid = nicknameField?.validate() ?? false;
    if (!isValid) return;

    final nickname = nicknameField?.value?.trim() ?? '';
    final available = await _checkNickname(nickname);

    if (!mounted) return;

    if (!available) {
      nicknameField?.invalidate('이미 사용 중인 닉네임입니다.');
      SaeipModalController.showText(
        context: context,
        message: '이미 사용 중인 닉네임입니다.',
        confirmBackgroundColor: AppColors.errorError3,
        cancelText: null,
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    textAlignVertical: TextAlignVertical.center,
                    maxLength: 10,
                    onChanged: (value) {
                      field.didChange(value);
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
                        padding: EdgeInsets.only(top: 16.h),
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
                const Gap(8),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    minimumSize: Size(76.w, 40.h),
                    side: BorderSide(color: labelColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: _handleDuplicateCheck,
                  child: Text(
                    '중복 확인',
                    style: AppTextStyles.smallMedium(
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
