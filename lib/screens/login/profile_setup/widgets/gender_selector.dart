import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: 'gender',
      validator: FormBuilderValidators.required(errorText: ''),
      builder: (FormFieldState<String?> field) {
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

            // 선택 UI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['남자', '여자'].map((gender) {
                final isSelected = field.value == gender;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => field.didChange(gender),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 160.w,
                        minHeight: 48.h,
                      ),
                      child: Center(
                        child: Text(
                          gender,
                          style: AppTextStyles.bodyRegular(
                            context,
                            color: isSelected
                                ? Colors.black
                                : AppColors.blackBlack4,
                          ),
                        ),
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
