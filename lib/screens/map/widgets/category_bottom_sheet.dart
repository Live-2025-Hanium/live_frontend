import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class CategoryAction {
  final String iconAsset;
  final String label;
  final String query;

  const CategoryAction({
    required this.iconAsset,
    required this.label,
    required this.query,
  });
}

// DraggableScrollableSheet 기반 바텀시트
class CategoryBottomSheet extends StatelessWidget {
  const CategoryBottomSheet({
    super.key,
    required this.items,
    required this.onCategoryTap,
    this.controller,
  });

  final List<CategoryAction> items;
  final void Function(CategoryAction action) onCategoryTap;

  // 프로그램적으로 열고 닫고 싶다면 주입 (e.g. controller.animateTo(...))
  final DraggableScrollableController? controller;

  @override
  Widget build(BuildContext context) {
    final controller = this.controller ?? DraggableScrollableController();
    final screenHeight = MediaQuery.of(context).size.height;
    final initialSize = 174 / screenHeight;

    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: initialSize,
      minChildSize: initialSize,
      maxChildSize: 0.98,
      snap: true,
      snapSizes: [initialSize, 0.42, 0.98],
      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          bottom: true,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              boxShadow: const [
                BoxShadow(blurRadius: 14, color: Colors.black26),
              ],
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                // 핸들 + 제목 영역
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap(10),
                      // 핸들
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.blackBlack2,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      Gap(12),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/marker.svg',
                              width: 13,
                              height: 16,
                            ),

                            Gap(8),

                            Flexible(
                              child: Text(
                                // TODO: 실제 현재 위치로 변경
                                '경기 고양시 덕양구 소원로 102',
                                style: AppTextStyles.smallMedium(context),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SliverToBoxAdapter(child: Gap(16)),

                // 카테고리 그리드
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // 4개 아이콘 1행
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.9, // 아이콘+라벨 비율
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = items[index];
                      return _CategoryButton(
                        icon: item.iconAsset,
                        label: item.label,
                        onTap: () => onCategoryTap(item),
                      );
                    }, childCount: items.length),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon, width: 40, height: 40),
          Gap(12),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.smallMedium(context),
          ),
        ],
      ),
    );
  }
}
