import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/providers/statistics_provider.dart';
import 'package:live_frontend/screens/statistics/widgets/monthly_compare_percent_card.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MonthlyCompareList extends ConsumerWidget {
  final Jiffy referenceDate;

  MonthlyCompareList({super.key, Jiffy? referenceDate})
    : referenceDate = referenceDate ?? Jiffy.now();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyGrowthAsync = ref.watch(
      monthlyGrowthProvider(referenceDate.format(pattern: 'yyyy-MM')),
    );

    return monthlyGrowthAsync.when(
      data: (data) {
        return Container(
          color: AppColors.blackBlack0,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data != null && data.growthSummary.isNotEmpty
                    ? '지난 달보다 이만큼 성장했어요!'
                    : '지난 달 데이터가 없어요.',
                style: AppTextStyles.subtitleMedium(context),
                textAlign: TextAlign.left,
              ),
              if (data != null && data.growthSummary.isNotEmpty)
                ...data.growthSummary.asMap().entries.expand((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return [
                    if (index > 0) Gap(16),
                    MonthlyComparePercentCard(
                      title: "Top ${index + 1}",
                      category: item.categoryName,
                      maxValue: 100,
                      currentValue: item.currentMonthCount,
                      previousValue: item.previousMonthCount,
                      referenceMonth: referenceDate,
                    ),
                  ];
                })
              else
                Column(
                  children: [
                    Gap(16),
                    Text(
                      '다음달에 다시 확인해주세요!',
                      style: AppTextStyles.bodyRegular(
                        context,
                        color: AppColors.blackBlack5,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
      loading: () {
        return SizedBox(
          height: 190,
          child: Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return SizedBox(
          height: 190,
          child: Center(
            child: Text(
              '데이터를 불러오는 중 오류가 발생했어요.',
              style: AppTextStyles.bodyRegular(context, color: Colors.red),
            ),
          ),
        );
      },
    );
  }
}
