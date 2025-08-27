import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class PostDetailHeader extends StatelessWidget {
  const PostDetailHeader({
    super.key,
    required this.categoryName,
    required this.orgName,
    required this.bookmarked,
    required this.onToggleBookmark,
    required this.authorNickname,
    required this.createdAt,
    required this.viewCount,
  });

  final String categoryName;
  final String orgName;
  final bool bookmarked;
  final VoidCallback onToggleBookmark;

  final String authorNickname;
  final DateTime createdAt;
  final int viewCount;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')}.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1행: 카테고리칩 + 기관 + 북마크 버튼
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.greenNormal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                categoryName,
                style: AppTextStyles.smallSemibold(context).copyWith(
                  color: AppColors.greenNormal,
                ),
              ),
            ),
            Gap(8.w),
            Expanded(
              child: Text(
                orgName,
                style: AppTextStyles.bodyRegular(context)
                    .copyWith(color: AppColors.blackBlack4),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: onToggleBookmark,
              icon: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border),
              splashRadius: 22.w,
            ),
          ],
        ),
        Gap(6.h),
        // 2행: 작성자/날짜/조회
        Row(
          children: [
            Text(
              authorNickname,
              style: AppTextStyles.bodyRegular(context),
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              dateStr,
              style: AppTextStyles.smallMedium(context)
                  .copyWith(color: AppColors.blackBlack4),
            ),
            Gap(8.w),
            Row(
              children: [
                Icon(Icons.visibility, size: 16.sp, color: AppColors.blackBlack3),
                Gap(4.w),
                Text(
                  viewCount.toString(),
                  style: AppTextStyles.smallMedium(context)
                      .copyWith(color: AppColors.blackBlack4),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
