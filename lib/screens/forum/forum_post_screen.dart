// lib/screens/forum/forum_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/utils/show_saeip_toast.dart';

import 'package:live_frontend/models/forum_post_detail_model.dart';
import 'package:live_frontend/providers/forum_post_detail_provider.dart';
import 'package:live_frontend/providers/forum_post_comments_controller.dart';

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
      error: (_, __) => const Scaffold(
        appBar: SaeipAppBar(),
        body: Center(child: Text('게시글을 불러오지 못했습니다.')),
      ),
      data: (detail) => _ForumPostView(detail: detail),
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
  final _scroll = ScrollController();
  final _commentInput = TextEditingController();
  final _commentFocus = FocusNode();

  Future<void> _onSendComment() async {
    final text = _commentInput.text.trim();
    if (text.isEmpty) return;

    final commentsCtrl = ref.read(
      postCommentsProvider(widget.detail.id).notifier,
    );
    final commentsState = ref.read(postCommentsProvider(widget.detail.id));

    try {
      if (commentsState.replyTo == null) {
        await commentsCtrl.addComment(text);
      } else {
        await commentsCtrl.addReply(commentsState.replyTo!.id, text);
      }
      _commentInput.clear();
      commentsCtrl.cancelReply();
    } catch (_) {
      SaeipToastController.showMessage(context, '댓글 등록 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;

    final detailState = ref.watch(forumPostDetailProvider(d.id));
    final detailCtrl = ref.read(forumPostDetailProvider(d.id).notifier);

    final commentsState = ref.watch(postCommentsProvider(d.id));
    final commentsCtrl = ref.read(postCommentsProvider(d.id).notifier);

    return Scaffold(
      appBar: SaeipAppBar(
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              detailState.isBookmarked
                  ? 'assets/icons/bookmark_green_filled.svg'
                  : 'assets/icons/bookmark_green_border.svg',
              height: 20,
            ),
            onPressed: () async {
              final prev = detailState.isBookmarked;
              try {
                await detailCtrl.toggleBookmark();
                SaeipToastController.showMessage(
                  context,
                  detailState.isBookmarked
                      ? '게시물 스크랩을 해제했습니다.'
                      : '게시물을 스크랩했습니다.',
                );
              } catch (_) {
                SaeipToastController.showMessage(
                  context,
                  prev ? '스크랩 해제에 실패하였습니다' : '스크랩에 실패하였습니다',
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: PostDetailCommentInput(
        controller: _commentInput,
        focusNode: _commentFocus,
        onSend: _onSendComment,
        replyTargetLabel: commentsState.replyTo != null
            ? '${commentsState.replyTo!.authorNickname}에게 답글'
            : null,
        onClearReplyTarget: commentsState.replyTo == null
            ? null
            : commentsCtrl.cancelReply,
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scroll,
          slivers: [
            // 게시글 본문
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  PostDetailHeader(
                    categoryName: d.category.name,
                    orgName: d.relatedOrganization,
                    authorNickname: d.authorNickname,
                    createdAt: d.createdAt,
                    viewCount: d.viewCount,
                    title: d.title,
                    commentCount: d.commentCount,
                  ),
                  Gap(8),
                  PostDetailContent(
                    content: d.content,
                    imageUrls: d.images.map((e) => e.s3Url).toList(),
                  ),
                  PostDetailReaction(
                    counts: detailState.reactions, // Map<ReactionType, int>
                    selected:
                        detailState.selectedReactions, // Set<ReactionType>
                    onToggle: ref
                        .read(forumPostDetailProvider(d.id).notifier)
                        .toggleReaction,
                  ),
                  Gap(12),
                ]),
              ),
            ),

            // 댓글 영역
            if (commentsState.roots.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('첫 댓글을 남겨주세요.')),
              )
            else
              PostDetailComments(
                comments: commentsState.roots,
                onTapMore: (_) {
                  // TODO: 대댓글 알림/수정/삭제 메뉴 연결
                },
                onTapLike: (c) => commentsCtrl.toggleLike(c.id),
                onTapReply: commentsCtrl.startReply,
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
