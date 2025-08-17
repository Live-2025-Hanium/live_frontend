// 디바운싱 적용
// 자동 완성 기능 필요한가??

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SaeipSearchBar extends StatelessWidget {
  const SaeipSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSubmitted,
    this.onChanged,
    this.onSearchTap,
    this.leading,
    this.accentColor = const Color(0xFF1A9C5F),
    this.elevation = 0,
    this.borderRadius = 12,
    this.showSearchButton = true,
    this.filledColor,
    this.borderColor,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchTap;

  // 로고/아이콘
  final Widget? leading;
  final Color accentColor;

  final double elevation;
  final double borderRadius;
  final bool showSearchButton;
  final Color? filledColor;
  final Color? borderColor;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final fill = filledColor ?? Colors.white;
    final border = borderColor ?? accentColor.withOpacity(0.6);

    return Material(
      color: fill,
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      shadowColor: Colors.black12,
      child: Row(
        children: [
          const SizedBox(width: 8),
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 6),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                isDense: true,
                contentPadding: contentPadding,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              onChanged: onChanged,
            ),
          ),
          if (showSearchButton)
            InkWell(
              onTap: onSearchTap ?? () => onSubmitted(controller.text),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: border, width: 1.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.search, color: accentColor, size: 18),
              ),
            ),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}