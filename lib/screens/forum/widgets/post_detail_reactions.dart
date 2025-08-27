import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class PostDetailReactions extends StatelessWidget {
  const PostDetailReactions({
    super.key,
    required this.empathyCount,
    required this.reactedEmpathy,
    required this.onToggleEmpathy,
    required this.onCommentTap,
    required this.onShare,
    required this.onScrap,
  });

  final int empathyCount;
  final bool reactedEmpathy;
  final VoidCallback onToggleEmpathy;
  final VoidCallback onCommentTap;
  final VoidCallback onShare;
  final VoidCallback onScrap;

  @override
  Widget build(BuildContext context) {
    TextStyle sub = AppTextStyles.smallMedium(context);

    Widget btn(IconData i, String t, VoidCallback onTap,
            {bool highlighted = false}) =>
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            child: Row(children: [
              Icon(i, size: 18.sp, color: highlighted ? Colors.redAccent : null),
              Gap(6.w),
              Text(t, style: sub),
            ]),
          ),
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        btn(
          reactedEmpathy ? Icons.favorite : Icons.favorite_border,
          empathyCount.toString(),
          onToggleEmpathy,
          highlighted: reactedEmpathy,
        ),
        btn(Icons.mode_comment_outlined, '댓글', onCommentTap),
        btn(Icons.ios_share, '공유', onShare),
        btn(Icons.bookmark_border, '스크랩', onScrap),
      ],
    );
  }
}
