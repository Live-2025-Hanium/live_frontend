import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

/// 화면 전용 반응 타입 (API enum과 별개)
enum ForumReaction { useful, encourage, willTry, empathy, thanks }

class PostDetailReactions extends StatelessWidget {
  const PostDetailReactions({
    super.key,
    required this.counts,
    required this.selected,
    required this.onToggle,
  });

  /// 각 반응의 카운트
  final Map<ForumReaction, int> counts;

  /// 현재 선택(내 반응)된 항목들
  final Set<ForumReaction> selected;

  /// 탭 시 토글 콜백
  final void Function(ForumReaction) onToggle;

  @override
  Widget build(BuildContext context) {

    const order = [
      ForumReaction.useful,
      ForumReaction.encourage,
      ForumReaction.willTry,
      ForumReaction.empathy,
      ForumReaction.thanks,
    ];

    return Row(
      children: order
          .map(
            (r) => Expanded(
              child: _ReactionCell(
                type: r,
                label: _labelOf(r),
                count: counts[r] ?? 0,
                selected: selected.contains(r),
                iconPath: (isActive) => _iconPathOf(r, isActive),
                onTap: () => onToggle(r),
              ),
            ),
          )
          .toList(),
    );
  }

  String _labelOf(ForumReaction r) {
    switch (r) {
      case ForumReaction.useful:
        return '유용해요';
      case ForumReaction.encourage:
        return '힘이 나요';
      case ForumReaction.willTry:
        return '해볼게요';
      case ForumReaction.empathy:
        return '공감해요';
      case ForumReaction.thanks:
        return '고마워요';
    }
  }

  String _iconPathOf(ForumReaction r, bool active) {
    final state = active ? 'on' : 'off';
    switch (r) {
      case ForumReaction.useful:
        return 'assets/icons/forum_post_detail/useful_$state.svg';
      case ForumReaction.encourage:
        return 'assets/icons/forum_post_detail/encourage_$state.svg';
      case ForumReaction.willTry:
        return 'assets/icons/forum_post_detail/will_try_$state.svg';
      case ForumReaction.empathy:
        return 'assets/icons/forum_post_detail/empathy_$state.svg';
      case ForumReaction.thanks:
        return 'assets/icons/forum_post_detail/thanks_$state.svg';
    }
  }
}

class _ReactionCell extends StatelessWidget {
  const _ReactionCell({
    required this.type,
    required this.label,
    required this.count,
    required this.selected,
    required this.iconPath,
    required this.onTap,
  });

  final ForumReaction type;
  final String label;
  final int count;
  final bool selected;
  final String Function(bool active) iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextStyles.smallMedium(context);
    final countStyle = AppTextStyles.bodyRegular(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath(selected),
              width: 40.w,
            ),
            Gap(8.h),
            Text(label, style: labelStyle),
            Gap(4.h),
            Text('$count', style: countStyle),
          ],
        ),
      ),
    );
  }
}
