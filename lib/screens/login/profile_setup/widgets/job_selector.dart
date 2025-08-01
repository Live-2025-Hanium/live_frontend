import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class JobSelector extends StatelessWidget {
  const JobSelector({super.key});

  static const List<String> jobs = [
    '학생',
    '직장인',
    '주부',
    '프리랜서/자영업',
    '무직/구직 중',
    '기타',
  ];

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
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
            const Gap(18),

            // 2열 고정 Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, // 2열 고정
              childAspectRatio: 160.w / 48.h,
              children: jobs.map((job) {
                final isSelected = selectedJob == job;

                return GestureDetector(
                  onTap: () => field.didChange(job),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 160.w,
                      minHeight: 48.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 직업명
                        Text(
                          job,
                          style: AppTextStyles.bodyRegular(
                            context,
                            color: isSelected
                                ? Colors.black
                                : (selectedJob == null
                                    ? Colors.black
                                    : AppColors.blackBlack4),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Gap(6),
                        // 밑줄
                        Container(
                          height: 1,
                          color: isSelected || selectedJob == null
                              ? AppColors.blackBlack1
                              : Colors.transparent,
                        ),
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
