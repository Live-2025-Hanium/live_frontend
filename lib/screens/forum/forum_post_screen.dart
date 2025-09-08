// lib/screens/forum/forum_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/utils/show_saeip_toast.dart';

import 'package:live_frontend/models/forum_post_detail_model.dart';
import 'package:live_frontend/providers/forum_post_detail_provider.dart';
import 'package:live_frontend/providers/forum_scrap_controller.dart';

import 'widgets/post_detail_header.dart';
import 'widgets/post_detail_content.dart';
import 'widgets/post_detail_reaction.dart';
import 'widgets/post_detail_comments.dart';
import 'widgets/post_detail_comment_input.dart';

class ForumPostScreen extends ConsumerWidget {
  const ForumPostScreen({super.key, required this.postId});
  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(postDetailProvider(postId));

    return detailAsync.when(
      loading: () => const Scaffold(
        appBar: SaeipAppBar(),
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => const Scaffold(
        appBar: SaeipAppBar(),
        body: Center(child: Text('게시글을 불러오지 못했습니다.')),
      ),
      data: (detail) => _ForumPostView(detail: detail as ForumPostDetailModel),
    );
  }
}

class _ForumPostView extends ConsumerStatefulWidget {
  const _ForumPostView({super.key, required this.detail});
  final ForumPostDetailModel detail;

  @override
  ConsumerState<_ForumPostView> createState() => _ForumPostViewState();
}

class _ForumPostViewState extends ConsumerState<_ForumPostView> {
  final ScrollController _scroll = ScrollController();
  final TextEditingController _commentInput = TextEditingController();

  @override
  void dispose() {
    _scroll.dispose();
    _commentInput.dispose();
    super.dispose();
  }

  void _onSendComment() {
    final text = _commentInput.text.trim();
    if (text.isEmpty) return;

    ref.read(forumPostProvider(widget.detail.id).notifier).addComment(text);
    _commentInput.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forumPostProvider(widget.detail.id));
    final notifier = ref.read(forumPostProvider(widget.detail.id).notifier);
    final d = widget.detail;
    final ui = ref.watch(forumPostProvider(d.id));

    return Scaffold(
      appBar: SaeipAppBar(
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              state.isBookmarked
                  ? 'assets/icons/bookmark_green_filled.svg'
                  : 'assets/icons/bookmark_green_border.svg',
              height: 20.h,
            ),
            onPressed: () async {
              final wasBookmarked = state.isBookmarked;

              // 1) 낙관적 UI: 먼저 토글
              notifier.toggleBookmark();

              try {
                // 2) 서버 토글 호출
                final isScraped = await ref
                    .read(scrapControllerProvider.notifier)
                    .toggleScrap(d.id);

                // 3) 서버 결과와 UI 동기화(서버 결과가 다르면 보정)
                //    - wasBookmarked: 서버 호출 전 상태
                //    - 현재 UI는 wasBookmarked를 반전시킨 상태
                //    - 서버 결과(isScraped)가 UI와 다르면 한번 더 토글해서 맞춤
                final uiNowBookmarked = !wasBookmarked;
                if (isScraped != uiNowBookmarked) {
                  notifier.toggleBookmark(); // 보정
                }

                // 4) 토스트
                SaeipToastController.showMessage(
                  context,
                  isScraped ? '게시글을 스크랩했습니다.' : '게시글 스크랩을 해제했습니다.',
                );
              } catch (e) {
                // 5) 실패 시 롤백
                notifier.toggleBookmark();
                SaeipToastController.showMessage(
                  context,
                  '스크랩 처리에 실패했습니다. 잠시 후 다시 시도해 주세요.',
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: PostDetailCommentInput(
        controller: _commentInput,
        onSend: _onSendComment,
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scroll,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Header
                  PostDetailHeader(
                    categoryName: widget.detail.category.name,
                    orgName: widget.detail.relatedOrganization,
                    authorNickname: widget.detail.authorNickname,
                    createdAt: widget.detail.createdAt,
                    viewCount: widget.detail.viewCount,
                    title: widget.detail.title,
                    commentCount: widget.detail.commentCount,
                  ),
                  Gap(8.h),

                  // Content
                  PostDetailContent(
                    content: widget.detail.content,
                    imageUrls: widget.detail.images
                        .map((e) => e.s3Url)
                        .toList(),
                  ),

                  // Reactions
                  PostDetailReactions(
                    counts: ui.reactions,
                    selected: ui.selectedReactions,
                    onToggle: (r) => ref
                        .read(forumPostProvider(d.id).notifier)
                        .toggleReaction(r),
                  ),
                  Gap(12.h),
                ]),
              ),
            ),

            // Comments
            if (state.comments.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyComments(),
              )
            else
              PostDetailComments(
                comments: state.comments,
                onTapMore: notifier.showCommentMenu,
                onTapLike: notifier.likeComment,
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

class _EmptyComments extends StatelessWidget {
  const _EmptyComments();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/comment.svg',
            width: 48.w,
            height: 48.w,
            fit: BoxFit.contain,
          ),
          Gap(12.h),
          Text(
            '첫 댓글을 남겨주세요.',
            style: AppTextStyles.bodyRegular(
              context,
            ).copyWith(color: AppColors.blackBlack4),
          ),
        ],
      ),
    );
  }
}
