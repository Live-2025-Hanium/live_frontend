import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:live_frontend/theme/app_colors.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '성별',
          style: TextStyle(
            color: AppColors.greenNormal,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        FormBuilderField<String>(
          name: 'gender',
          validator: FormBuilderValidators.required(),
          builder: (FormFieldState<String?> field) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['남자', '여자'].map((gender) {
                final isSelected = field.value == gender;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => field.didChange(gender),
                    child: Column(
                      children: [
                        Text(
                          gender,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : AppColors.blackBlack4,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 1,
                          color: isSelected
                              ? Colors.black
                              : Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
