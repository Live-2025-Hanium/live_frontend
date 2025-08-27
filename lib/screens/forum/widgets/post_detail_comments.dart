import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import '../forum_post_screen.dart' show PostComment; // 로컬 댓글 모델 재사용

class PostDetailComments extends StatelessWidget {
  const PostDetailComments({
    super.key,
    required this.comments,
    required this.onTapMore,
    required this.onTapLike,
  });

  final List<PostComment> comments;
  final void Function(PostComment) onTapMore;
  final void Function(PostComment) onTapLike;

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
              '${c.date.year}.${c.date.month.toString().padLeft(2, '0')}.${c.date.day.toString().padLeft(2, '0')}';
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 16.r, child: Text(c.user.characters.first)),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              c.user,
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
                      Text(c.text, style: AppTextStyles.bodyRegular(context)),
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
                                const Icon(Icons.favorite_border, size: 16),
                                Gap(4.w),
                                Text(c.likes.toString(),
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
