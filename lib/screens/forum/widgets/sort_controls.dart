import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum ForumSort { latest, views, scraps }

extension ForumSortLabel on ForumSort {
  String get label {
    switch (this) {
      case ForumSort.latest:
        return '최신순';
      case ForumSort.views:
        return '조회수 높은 순';
      case ForumSort.scraps:
        return '스크랩 많은 순';
    }
  }
}

class SortControls extends StatefulWidget {
  const SortControls({
    super.key,
    required this.value,
    required this.onChanged,
    this.menuWidth = 120,
    this.menuRadius = 8,
    this.menuElevation = 12,
  });

  final ForumSort value;
  final ValueChanged<ForumSort> onChanged;

  final double menuWidth;
  final double menuRadius;
  final double menuElevation;

  @override
  State<SortControls> createState() => _SortControlsState();
}

class _SortControlsState extends State<SortControls> {
  final _anchorKey = GlobalKey();
  bool _open = false;

  Future<void> _openMenu() async {
    final box = _anchorKey.currentContext!.findRenderObject() as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final anchor = RelativeRect.fromRect(
      box.localToGlobal(Offset.zero, ancestor: overlay) & box.size,
      Offset.zero & overlay.size,
    );

    setState(() => _open = true);

    final selected = await showMenu<ForumSort>(
      context: context,
      position: anchor.shift(const Offset(0, 32)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.menuRadius),
      ),
      elevation: widget.menuElevation,
      constraints: BoxConstraints(
        maxWidth: widget.menuWidth.w,
      ),
      items: [
        for (int i = 0; i < ForumSort.values.length; i++)
          PopupMenuItem<ForumSort>(
            value: ForumSort.values[i],
            padding: EdgeInsets.zero,
            child: _MenuItem(
              label: ForumSort.values[i].label,
              selected: ForumSort.values[i] == widget.value,
              showDivider: i != ForumSort.values.length - 1,
            ),
          ),
      ],
    );

    setState(() => _open = false);

    if (selected != null && selected != widget.value) {
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.smallMedium(context);

    return GestureDetector(
      key: _anchorKey,
      behavior: HitTestBehavior.opaque,
      onTap: _openMenu,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.value.label, style: style),
          Gap(8.w),
          AnimatedRotation(
            duration: const Duration(milliseconds: 150),
            turns: _open ? 0.0 : 0.5,
            child: SvgPicture.asset(
              'assets/icons/arrow_down.svg',
              width: 12.w,
              height: 6.w,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.label,
    required this.selected,
    required this.showDivider,
  });

  final String label;
  final bool selected;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final base = selected
        ? AppTextStyles.bodyRegular(
            context,
          ).copyWith(color: AppColors.greenNormal)
        : AppTextStyles.bodyRegular(context).copyWith(color: Colors.black);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.08),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Text(label, style: base),
    );
  }
}
