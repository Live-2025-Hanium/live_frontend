import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/models/forum_post_comment_model.dart';

class PostDetailComments extends StatelessWidget {
  const PostDetailComments({
    super.key,
    required this.comments,
    required this.onTapMore,
    required this.onTapLike,
  });

  final List<ForumPostComment> comments;
  final void Function(ForumPostComment) onTapMore;
  final void Function(ForumPostComment) onTapLike;

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            SvgPicture.asset('assets/icons/comment_empty.svg',
                width: 88.w, height: 88.w, fit: BoxFit.contain),
            Gap(12.h),
            Text('첫 댓글을 남겨주세요.',
                style: AppTextStyles.bodyRegular(context)
                    .copyWith(color: AppColors.blackBlack4)),
          ]),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList.builder(
        itemCount: comments.length,
        itemBuilder: (context, i) {
          final c = comments[i];
          final date =
              '${c.createdAt.year}.${c.createdAt.month.toString().padLeft(2, '0')}.${c.createdAt.day.toString().padLeft(2, '0')}';
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 16.r, child: Text(c.authorNickname.characters.first)),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.authorNickname,
                              style: AppTextStyles.bodyMedium(context),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            date,
                            style: AppTextStyles.smallMedium(context)
                                .copyWith(color: AppColors.blackBlack4),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () => onTapMore(c),
                            splashRadius: 20.w,
                          ),
                        ],
                      ),
                      Text(c.content, style: AppTextStyles.bodyRegular(context)),
                      Gap(6.h),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => onTapLike(c),
                            borderRadius: BorderRadius.circular(6.r),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 4.h),
                              child: Row(children: [
                                Icon(
                                  c.isLiked 
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 16,
                                  color: c.isLiked 
                                      ? AppColors.pinkNormal 
                                      : AppColors.blackBlack3,
                                ),
                                Gap(4.w),
                                Text(c.likeCount.toString(),
                                    style: AppTextStyles.smallMedium(context)),
                              ]),
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text('답글 달기'),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
