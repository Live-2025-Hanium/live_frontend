import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    this.accentColor = const Color(0xFF1A9C5F),
    this.height = 40,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.spacing = 6,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  final Color accentColor;
  final double height;
  final EdgeInsets padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: padding,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          return ChoiceChip(
            label: Text(categories[i]),
            selected: selected,
            onSelected: (_) => onSelected(i),
            labelStyle: TextStyle(
              color: selected ? accentColor : Colors.black87,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
            side: BorderSide(
              color: selected ? accentColor : Colors.transparent,
              width: 1.4,
            ),
            backgroundColor: Colors.transparent,
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: spacing),
        itemCount: categories.length,
      ),
    );
  }
}
