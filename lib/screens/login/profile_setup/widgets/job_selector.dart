import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/profile_model.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class JobSelector extends StatelessWidget {
  const JobSelector({super.key});

  static const List<Occupation> jobs = [
    Occupation.student,
    Occupation.employee,
    Occupation.homemaker,
    Occupation.freelancer,
    Occupation.unemployed,
    Occupation.other,
  ];

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<Occupation>(
      name: 'job',
      validator: FormBuilderValidators.required(errorText: ''),
      builder: (field) {
        final selectedJob = field.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 라벨
            Text(
              '현재 하시는 일을 알려주세요.',
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.greenNormal,
              ),
            ),
            Gap(18),

            // 2열 고정 Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, // 2열 고정
              // GridView의 자식 요소는 TextButton의 최소 크기와 동일한 비율로 설정하는 것이 좋습니다.
              // TextButton이 ConstrainedBox의 역할을 하므로, 필요하다면 childAspectRatio를 조정하세요.
              childAspectRatio: 160 / 48,
              children: jobs.map((job) {
                final isSelected = selectedJob == job;

                // 색상 로직
                final textColor = isSelected
                    ? Colors.black
                    : (selectedJob == null
                          ? Colors.black
                          : AppColors.blackBlack4);
                final underlineColor = isSelected || selectedJob == null
                    ? AppColors.blackBlack1
                    : Colors.transparent;

                return Padding(
                  padding: EdgeInsets.zero,
                  child: TextButton(
                    onPressed: () => field.didChange(job),
                    style: TextButton.styleFrom(
                      minimumSize: Size(160, 48),
                      padding: EdgeInsets.zero,
                      foregroundColor: Colors.transparent, // 눌릴 때 물결 효과 색상
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min, // Column이 차지하는 높이를 최소화
                      children: [
                        Text(
                          job.description,
                          style: AppTextStyles.bodyRegular(
                            context,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gap(6),
                        Container(height: 1, color: underlineColor),
                      ],
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
