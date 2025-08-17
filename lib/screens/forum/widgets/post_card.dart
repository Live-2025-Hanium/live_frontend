import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class ForumPost {
  final String id;
  final String title;
  final DateTime date;
  final String imageUrl;

  const ForumPost({
    required this.id,
    required this.title,
    required this.date,
    required this.imageUrl,
  });
}

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, this.onTap});

  final ForumPost post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${post.date.year}.${post.date.month.toString().padLeft(2, '0')}.${post.date.day.toString().padLeft(2, '0')}';

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
              child: Image.network(post.imageUrl, fit: BoxFit.cover),
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
