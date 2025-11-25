import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/map_model.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MapBottomSheet extends StatefulWidget {
  final bool showCategories;

  const MapBottomSheet({super.key, required this.showCategories});

  @override
  State<MapBottomSheet> createState() => _MapBottomSheetState();
}

class _MapBottomSheetState extends State<MapBottomSheet> {
  final List<Map<PlaceCategory, String>> categories = [
    {PlaceCategory.lei: 'assets/icons/map_category/leisure.svg'},
    {PlaceCategory.psy: 'assets/icons/map_category/mental_clinic.svg'},
    {PlaceCategory.wel: 'assets/icons/map_category/welfare_center.svg'},
    {PlaceCategory.csc: 'assets/icons/map_category/counseling_center.svg'},
  ];

  bool _showCategories = true;

  // 상태변수 초기화
  @override
  void initState() {
    super.initState();
    _showCategories = widget.showCategories;
  }

  void _toggleCategories(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0.0;

    if (velocity > 0) {
      // 아래로 스와이프
      setState(() {
        _showCategories = false;
      });
    } else {
      // 위로 스와이프
      setState(() {
        _showCategories = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragEnd: _toggleCategories,
      onPanDown: (_) {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.blackBlack2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Gap(14),
            Row(
              children: [
                SvgPicture.asset('assets/icons/location.svg'),
                Gap(8),
                Text("위치", style: AppTextStyles.smallMedium(context)),
              ],
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  const Gap(32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: categories
                        .map(
                          (categoryMap) => _buildCategoryItem(
                            categoryMap.values.first,
                            categoryMap.keys.first.displayName,
                            context,
                          ),
                        )
                        .toList(),
                  ),
                  const Gap(32),
                ],
              ),
              crossFadeState: _showCategories
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    String iconPath,
    String label,
    BuildContext context,
  ) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        children: [
          SizedBox(height: 40, width: 40, child: SvgPicture.asset(iconPath)),
          Gap(12),
          Text(
            label,
            style: AppTextStyles.smallMedium(context, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
