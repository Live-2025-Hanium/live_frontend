import 'package:flutter/material.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    this.height = 48,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.spacing = 20,
    this.showBottomDivider = true,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final double height;
  final EdgeInsets padding;
  final double spacing;
  final bool showBottomDivider;

  @override
  Widget build(BuildContext context) {
    final divider = BorderSide(color: AppColors.greenLight, width: 1);

    return Container(
      height: height,
      decoration: showBottomDivider
          ? BoxDecoration(border: Border(bottom: divider))
          : null,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;

          return Material(
            child: InkWell(
              onTap: () => onSelected(i),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    categories[i],
                    style: selected
                        ? AppTextStyles.bodySemibold(
                            context,
                            color: AppColors.greenNormal,
                          )
                        : AppTextStyles.bodyRegular(context),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: spacing),
        itemCount: categories.length,
      ),
    );
  }
}
