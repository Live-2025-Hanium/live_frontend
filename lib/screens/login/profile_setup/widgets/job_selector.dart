import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class JobSelector extends StatelessWidget {
  const JobSelector({super.key});

  final List<String> jobs = const [
    '학생',
    '직장인',
    '주부',
    '프리랜서/자영업',
    '무직/구직 중',
    '기타',
  ];

  @override
  Widget build(BuildContext context) {
    return FormBuilderChoiceChips<String>(
      name: 'job',
      decoration: const InputDecoration(labelText: '현재 하시는 일'),
      options:
          jobs
              .map((job) => FormBuilderChipOption(value: job, child: Text(job)))
              .toList(),
      validator: FormBuilderValidators.required(),
    );
  }
}
