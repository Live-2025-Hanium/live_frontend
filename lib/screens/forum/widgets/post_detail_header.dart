import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // 추가
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class PostDetailHeader extends StatelessWidget {
  const PostDetailHeader({
    super.key,
    required this.categoryName,
    required this.orgName,
    required this.authorNickname,
    required this.createdAt,
    required this.viewCount,
    required this.title,
    required this.commentCount,
  });

  final String categoryName;
  final String orgName;
  final String authorNickname;
  final DateTime createdAt;
  final int viewCount;
  final String title;
  final int commentCount;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')}.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1행: 카테고리칩 + 기관
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.greenDark,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                categoryName,
                style: AppTextStyles.smallSemibold(
                  context,
                ).copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        Gap(12.h),
        // 2행: 제목
        Text(title, style: AppTextStyles.titleSemibold(context)),
        Gap(8.h),

        // 3행: 메타정보
        Text('$authorNickname', style: AppTextStyles.bodyRegular(context)),
        Gap(24.h),
        Row(
          children: [
            Text(dateStr, style: AppTextStyles.smallMedium(context)),
            const Spacer(),
            _MetaItem('assets/icons/cursor.svg', viewCount.toString()),
            Gap(16.w),
            _MetaItem('assets/icons/comment.svg', commentCount.toString()),
          ],
        ),
        Gap(32.h)
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem(this.icon, this.text);
  final String icon; // IconData에서 String으로 변경
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, width: 12.sp, height: 12.sp),
        Gap(4.w),
        Text(text, style: AppTextStyles.smallMedium(context)),
      ],
    );
  }
}
