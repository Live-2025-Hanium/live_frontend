import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class BirthdaySelector extends StatelessWidget {
  const BirthdaySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final formState = FormBuilder.of(context);
    final hasError = [
      'year',
      'month',
      'day',
    ].any((field) => formState?.fields[field]?.hasError == true);

    final labelColor = hasError ? AppColors.errorError3 : AppColors.greenNormal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '생년월일',
          style: AppTextStyles.bodyMedium(context, color: labelColor),
        ),
        const Gap(18),
        Row(
          children: const [
            _DatePartField(name: 'year', unitLabel: '년'),
            Gap(8),
            _DatePartField(name: 'month', unitLabel: '월'),
            Gap(8),
            _DatePartField(name: 'day', unitLabel: '일'),
          ],
        ),
      ],
    );
  }
}

class _DatePartField extends StatelessWidget {
  final String name;
  final String unitLabel;

  const _DatePartField({
    required this.name,
    required this.unitLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FormBuilderField<int>(
        name: name,
        validator: FormBuilderValidators.required(errorText: ''),
        builder: (field) {
          final isSelected = field.value != null;

          return GestureDetector(
            onTap: () async {
              final selectedDate = await _pickDate(context);
              if (selectedDate != null) {
                _updateAllFields(context, selectedDate, name);
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          isSelected ? '${field.value}' : '',
                          style: AppTextStyles.bodyRegular(
                            context,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      unitLabel,
                      style: AppTextStyles.bodyRegular(
                        context,
                        color: AppColors.blackBlack4,
                      ),
                    ),
                  ],
                ),
                const Gap(6),
                Container(height: 1, color: AppColors.blackBlack1),
              ],
            ),
          );
        },
      ),
    );
  }

  static Future<DateTime?> _pickDate(BuildContext context) {
    return showDialog<DateTime>(
      context: context,
      builder: (_) => Localizations(
        locale: const Locale('ko', 'KR'),
        delegates: GlobalMaterialLocalizations.delegates,
        child: Builder(
          builder: (ctx) => DatePickerDialog(
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 100),
            lastDate: DateTime.now(),
          ),
        ),
      ),
    );
  }

  static void _updateAllFields(
    BuildContext context,
    DateTime selectedDate,
    String changedField,
  ) {
    final formState = FormBuilder.of(context);
    if (formState == null) return;

    formState.fields['year']?.didChange(selectedDate.year);
    formState.fields['month']?.didChange(selectedDate.month);
    formState.fields['day']?.didChange(selectedDate.day);
  }
}
