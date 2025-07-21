import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/screens/login/widgets/nickname_field.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _nicknameController = TextEditingController();

  final List<String> jobs = ['학생', '직장인', '주부', '프리랜서/자영업', '무직/구직 중', '기타'];

  final years = List.generate(100, (i) => DateTime.now().year - i);
  final months = List.generate(12, (i) => i + 1);
  final days = List.generate(31, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(lastPage: '/terms'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey,
                    child: Text('변경', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 24),
                NicknameField(),

                const SizedBox(height: 20),
                FormBuilderRadioGroup(
                  name: 'gender',
                  decoration: const InputDecoration(labelText: '성별'),
                  options: const [
                    FormBuilderFieldOption(value: '남자'),
                    FormBuilderFieldOption(value: '여자'),
                  ],
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FormBuilderDropdown<int>(
                        name: 'year',
                        decoration: const InputDecoration(labelText: '년'),
                        items:
                            years
                                .map(
                                  (y) => DropdownMenuItem(
                                    value: y,
                                    child: Text('$y'),
                                  ),
                                )
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
                                .map(
                                  (m) => DropdownMenuItem(
                                    value: m,
                                    child: Text('$m'),
                                  ),
                                )
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
                                .map(
                                  (d) => DropdownMenuItem(
                                    value: d,
                                    child: Text('$d'),
                                  ),
                                )
                                .toList(),
                        validator: FormBuilderValidators.required(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FormBuilderChoiceChips<String>(
                  name: 'job',
                  decoration: const InputDecoration(labelText: '현재 하시는 일'),
                  options:
                      jobs
                          .map(
                            (job) => FormBuilderChipOption(
                              value: job,
                              child: Text(job),
                            ),
                          )
                          .toList(),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final formData = _formKey.currentState!.value;
                      // print('폼 데이터: $formData');
                      context.pushNamed('home');
                    } else {
                      print('폼 유효성 오류');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
