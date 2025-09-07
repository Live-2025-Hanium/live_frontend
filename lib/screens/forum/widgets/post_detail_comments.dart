import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:characters/characters.dart';

import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/models/forum_post_comment_model.dart';

class PostDetailComments extends StatelessWidget {
  const PostDetailComments({
    super.key,
    required this.comments,
    required this.onTapMore,
    required this.onTapLike,
    this.avatarUrlBuilder,
  });

  final List<ForumPostCommentModel> comments;
  final void Function(ForumPostCommentModel) onTapMore;
  final void Function(ForumPostCommentModel) onTapLike;
  final String? Function(ForumPostCommentModel comment)? avatarUrlBuilder;

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyComments(),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => _CommentTile(
          comment: comments[i],
          onTapMore: onTapMore,
          onTapLike: onTapLike,
          avatarUrl: avatarUrlBuilder?.call(comments[i]),
        ),
        childCount: comments.length,
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.onTapMore,
    required this.onTapLike,
    this.avatarUrl,
  });

  final ForumPostCommentModel comment;
  final void Function(ForumPostCommentModel) onTapMore;
  final void Function(ForumPostCommentModel) onTapLike;
  final String? avatarUrl;

  String _fmt(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final mi = d.minute.toString().padLeft(2, '0');
    return '$mm/$dd $hh:$mi';
  }

  String _seedAvatarUrl(int seed) =>
      'https://i.pravatar.cc/120?img=${(seed % 70) + 1}';

  @override
  Widget build(BuildContext context) {
    final dateTime = _fmt(comment.createdAt);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.blackBlack3, width: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 헤더: 아바타 + (닉/날짜/더보기) + 우측 좋아요 ─────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Avatar(
                  radius: 18.r,
                  url: (avatarUrl != null && avatarUrl!.isNotEmpty)
                      ? avatarUrl
                      : _seedAvatarUrl(comment.id),
                  fallbackText: comment.authorNickname.characters.isEmpty
                      ? '?'
                      : comment.authorNickname.characters.first,
                ),
                Gap(12.w),

                // 닉네임/날짜/(내 댓글이면 더보기)
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          comment.authorNickname,
                          style: AppTextStyles.bodyMedium(context),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gap(8.w),
                      Text(
                        dateTime,
                        style: AppTextStyles.smallMedium(context)
                            .copyWith(color: AppColors.blackBlack4),
                      ),
                      if (comment.isMyComment) ...[
                        Gap(4.w),
                        IconButton(
                          iconSize: 20.sp,
                          icon: const Icon(Icons.more_vert),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 18.w,
                          onPressed: () => onTapMore(comment),
                        ),
                      ],
                    ],
                  ),
                ),

                // 우측 좋아요(아이콘 + 카운트)
                Gap(8.w),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => onTapLike(comment),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          comment.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 22.sp,
                          color: AppColors.pinkNormal,
                        ),
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      '${comment.likeCount}',
                      style: AppTextStyles.smallMedium(context)
                          .copyWith(color: AppColors.blackBlack3),
                    ),
                  ],
                ),
              ],
            ),

            // ── 본문: 컨테이너(=아바타의 왼쪽선)와 좌측 정렬 ────────────────────────
            Gap(8.h),
            Text(
              comment.content,
              style: AppTextStyles.bodyRegular(context),
            ),

            Gap(16.h),
            Text(
              '답글 달기',
              style: AppTextStyles.smallMedium(context)
                  .copyWith(color: AppColors.blackBlack4),
            ),
          ],
        ),
      ),
    );
  }
}

/// 네트워크 아바타 + 실패 시 이니셜 폴백
class _Avatar extends StatelessWidget {
  const _Avatar({required this.radius, required this.fallbackText, this.url});

  final double radius;
  final String fallbackText;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    if (url != null && url!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          url!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              CircleAvatar(radius: radius, child: Text(fallbackText)),
        ),
      );
    }
    return CircleAvatar(radius: radius, child: Text(fallbackText));
  }
}

class _EmptyComments extends StatelessWidget {
  const _EmptyComments();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SvgPicture.asset('assets/icons/comment_empty.svg',
            width: 88.w, height: 88.w, fit: BoxFit.contain),
        Gap(12.h),
        Text(
          '첫 댓글을 남겨주세요.',
          style: AppTextStyles.bodyRegular(context)
              .copyWith(color: AppColors.blackBlack4),
        ),
      ]),
    );
  }
}
