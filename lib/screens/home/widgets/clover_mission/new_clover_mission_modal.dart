import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/screens/home/widgets/clover_mission/clover_sub_content.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/models/clover_mission_model.dart';
import 'package:live_frontend/providers/home_provider.dart';

class NewCloverMissionModal extends ConsumerStatefulWidget {
  final bool isAdditional;

  const NewCloverMissionModal({super.key, this.isAdditional = false});

  @override
  ConsumerState<NewCloverMissionModal> createState() =>
      _NewCloverMissionModalState();
}

class _NewCloverMissionModalState extends ConsumerState<NewCloverMissionModal> {
  List<CloverMissionModel>? _missions;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isAdditional) {
      _loading = true;
      // fetch additional missions via notifier
      ref
          .read(cloverMissionNotifierProvider.notifier)
          .addMission()
          .then((list) {
            if (!mounted) return;
            setState(() {
              _missions = list;
              _loading = false;
            });
          })
          .catchError((_) {
            if (!mounted) return;
            setState(() {
              _missions = [];
              _loading = false;
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (widget.isAdditional) {
      if (_loading) {
        content = const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );
      } else {
        final list = _missions ?? [];
        content = _buildContent(context, list, '추가 클로버 미션');
      }
    } else {
      final missionListAsync = ref.watch(cloverMissionNotifierProvider);
      content = missionListAsync.when(
        loading: () => const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, s) =>
            SizedBox(height: 200, child: Center(child: Text('Error: $e'))),
        data: (missionList) =>
            _buildContent(context, missionList, '클로버 미션 도착!'),
      );
    }

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.fromLTRB(16.w, 36.h, 16.w, 4.h),
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
    List<CloverMissionModel> missionList,
    String titleText,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: AppTextStyles.titleMedium(context, color: Colors.black),
          textAlign: TextAlign.center,
        ),
        Gap(12.h),
        Image.asset(
          // 이유는 모르겠는데 svg가 안됨.
          'assets/images/clover.png',
          width: 52.w,
          height: 52.w,
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
        padding: EdgeInsets.symmetric(horizontal: 22.w),
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
            Gap(24.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyRegular(
                    context,
                    color: Colors.black,
                  ),
                ),
                Gap(4.h),
                CloverSubContent(difficulty: difficulty, category: category),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
