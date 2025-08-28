import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/models/forum_post_model.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, this.onTap});

  final ForumPost post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${post.createdAt.year}.${post.createdAt.month.toString().padLeft(2, '0')}.${post.createdAt.day.toString().padLeft(2, '0')}';

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 썸네일
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1.33,
              child: Image.network(post.thumbnailImageUrl ?? 'https://via.placeholder.com/300', fit: BoxFit.cover),
            ),
          ),

          Gap(8.h),

          // 제목
          Text(
            post.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyRegular(context),
          ),

          Gap(4.h),

          // 날짜
          Text(
            dateStr,
            style: AppTextStyles.smallMedium(
              context,
              color: AppColors.blackBlack4,
            ),
          ),
        ],
      ),
    );
  }
}
