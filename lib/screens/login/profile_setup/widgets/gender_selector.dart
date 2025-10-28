import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/profile_model.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key});

  static const List<Gender> genders = [Gender.male, Gender.female];

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<Gender>(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextButton(
                      onPressed: () => field.didChange(gender),
                      style: TextButton.styleFrom(
                        minimumSize: Size(160, 48),
                        padding: EdgeInsets.zero,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 텍스트
                          Text(
                            gender.description,
                            style: AppTextStyles.bodyRegular(
                              context,
                              color: textColor,
                            ),
                          ),
                          const Gap(6),
                          // 밑줄
                          Container(height: 1, color: underlineColor),
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
