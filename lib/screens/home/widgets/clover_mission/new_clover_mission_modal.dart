import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/providers/clover_mission_provider.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission/clover_sub_content.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/models/clover_mission_model.dart';

class NewCloverMissionModal extends ConsumerWidget {
  final bool isAdditional;

  const NewCloverMissionModal({super.key, this.isAdditional = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content;
    if (isAdditional) {
      final missionListAsync = ref.watch(newCloverMissionProvider(null));
      content = missionListAsync.when(
        loading: () => const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, s) =>
            SizedBox(height: 200, child: Center(child: Text('에러 발생'))),
        data: (missionList) {
          return _buildContent(
            context,
            ref,
            missionList ?? [],
            '추가 클로버 미션 도착!',
          );
        },
      );
    } else {
      final missionListAsync = ref.watch(cloverMissionProvider(null));
      content = missionListAsync.when(
        loading: () => const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, s) =>
            SizedBox(height: 200, child: Center(child: Text('에러 발생'))),
        data: (missionList) =>
            _buildContent(context, ref, missionList ?? [], '클로버 미션 도착!'),
      );
    }

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.fromLTRB(16, 36, 16, 4),
            width: double.infinity,
            child: content,
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: Icon(Icons.close, color: AppColors.blackBlack4),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<CloverMissionModel> missionList,
    String titleText,
  ) {
    ref.invalidate(cloverMissionProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: AppTextStyles.titleMedium(context, color: Colors.black),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        Gap(12),
        Image.asset(
          // 이유는 모르겠는데 svg가 안됨.
          'assets/images/clover.png',
          width: 52,
          height: 52,
        ),
        Gap(24.h),
        ...missionList.asMap().entries.map((entry) {
          final idx = entry.key;
          final data = entry.value;
          return Column(
            children: [
              _buildTile(
                context,
                idx,
                data.missionTitle,
                data.missionDifficulty,
                data.missionCategory,
              ),
              Gap(8.h),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildTile(
    BuildContext context,
    int index,
    String title,
    CloverMissionDifficulty difficulty,
    CloverMissionCategory category,
  ) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
        border: Border.all(color: AppColors.blackBlack1, width: 1.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${index + 1}',
              style: AppTextStyles.titleMedium(
                context,
                color: AppColors.blackBlack4,
              ),
            ),
            Gap(24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyRegular(
                      context,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(4),
                  CloverSubContent(difficulty: difficulty, category: category),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
