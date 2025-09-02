import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key});

  static const List<String> genders = ['남자', '여자'];

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: 'gender',
      validator: FormBuilderValidators.required(errorText: ''),
      builder: (field) {
        final selectedGender = field.value;
        final hasError = field.hasError;
        const errorColor = AppColors.errorError3;
        final labelColor = hasError ? errorColor : AppColors.greenNormal;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 라벨
            Text(
              '성별',
              style: AppTextStyles.bodyMedium(context, color: labelColor),
            ),
            const Gap(12),

            // 선택 UI (가로 2개 배치)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: genders.map((gender) {
                final isSelected = selectedGender == gender;

                // 색상/밑줄 로직
                final textColor = isSelected
                    ? Colors.black
                    : (selectedGender == null
                        ? Colors.black
                        : AppColors.blackBlack4);
                final underlineColor = isSelected || selectedGender == null
                    ? AppColors.blackBlack1
                    : Colors.transparent;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => field.didChange(gender),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 160.w,
                        minHeight: 48.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 텍스트
                          Text(
                            gender,
                            style: AppTextStyles.bodyRegular(
                              context,
                              color: textColor,
                            ),
                          ),
                          const Gap(6),
                          // 밑줄
                          Container(
                            height: 1,
                            color: underlineColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
