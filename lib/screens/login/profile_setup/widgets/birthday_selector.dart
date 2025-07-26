import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class BirthdaySelector extends StatelessWidget {
  const BirthdaySelector({super.key});

  List<int> get years => List.generate(100, (i) => DateTime.now().year - i);
  List<int> get months => List.generate(12, (i) => i + 1);
  List<int> get days => List.generate(31, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FormBuilderDropdown<int>(
            name: 'year',
            decoration: const InputDecoration(labelText: '년'),
            items:
                years
                    .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                    .toList(),
            validator: FormBuilderValidators.required(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FormBuilderDropdown<int>(
            name: 'month',
            decoration: const InputDecoration(labelText: '월'),
            items:
                months
                    .map((m) => DropdownMenuItem(value: m, child: Text('$m')))
                    .toList(),
            validator: FormBuilderValidators.required(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FormBuilderDropdown<int>(
            name: 'day',
            decoration: const InputDecoration(labelText: '일'),
            items:
                days
                    .map((d) => DropdownMenuItem(value: d, child: Text('$d')))
                    .toList(),
            validator: FormBuilderValidators.required(),
          ),
        ),
      ],
    );
  }
}
