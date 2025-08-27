// lib/screens/forum/forum_post_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';

import 'package:live_frontend/screens/404/not_found_screen.dart';
import 'package:live_frontend/models/forum_post_detail_model.dart';
import 'package:live_frontend/providers/forum_post_detail_provider.dart';
import 'widgets/post_detail_header.dart';
import 'widgets/post_detail_reactions.dart';
import 'widgets/post_detail_comments.dart';

class ForumPostScreen extends ConsumerWidget {
  const ForumPostScreen({super.key, required this.postId});
  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(postDetailProvider(postId));

    return detailAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
      // ⚠️ 여기서 Scaffold로 감싸지 말고 뷰를 그대로 반환
      data: (detail) => _ForumPostView(detail: detail),
    );
  }
}

class _ForumPostView extends ConsumerStatefulWidget {
  const _ForumPostView({super.key, required this.detail});
  final PostDetail detail;

  @override
  ConsumerState<_ForumPostView> createState() => _ForumPostViewState();
}

class _ForumPostViewState extends ConsumerState<_ForumPostView> {
  final ScrollController _scroll = ScrollController();
  final TextEditingController _commentInput = TextEditingController();

  // 스크랩 on/off
  late bool _bookmarked;

  // 반응 상태(부모에서 관리해 내려주기)
  late Map<ForumReaction, int> _counts;
  late Set<ForumReaction> _selected;

  // 간단한 로컬 댓글 목업
  final List<PostComment> _comments = <PostComment>[
    PostComment(
      id: 1,
      user: 'Karina',
      date: DateTime(2017, 3, 19),
      text: '저도 강아지를 키우고 나서 집에 있는 시간이 훨씬 늘었어요.',
      likes: 2,
    ),
    PostComment(
      id: 2,
      user: '민들레',
      date: DateTime(2017, 3, 19),
      text: '근데 같이 살던 강아지 죽었던 게… ㅠ',
      likes: 5,
    ),
    PostComment(
      id: 3,
      user: '오늘도 이지아',
      date: DateTime(2017, 3, 19),
      text: '공감이 많이 가는 글입니다.',
      likes: 13,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bookmarked = false;
    _initReactions(widget.detail);
  }

  void _initReactions(PostDetail d) {
    // 기본 0으로 채우고, 스펙에 있는 항목만 매핑 (현재 empathy만 존재)
    _counts = {
      ForumReaction.useful: 0,
      ForumReaction.encourage: 0,
      ForumReaction.willTry: 0,
      ForumReaction.empathy: d.reactionCounts[ReactionType.empathy] ?? 0,
      ForumReaction.thanks: 0,
    };
    _selected = <ForumReaction>{};
    if (d.userReactions.contains(ReactionType.empathy)) {
      _selected.add(ForumReaction.empathy);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    _commentInput.dispose();
    super.dispose();
  }

  // ---- interactions ----
  void _toggleBookmark() {
    setState(() => _bookmarked = !_bookmarked);
    _toast(_bookmarked ? '스크랩했습니다.' : '스크랩을 취소했습니다.');
  }

  void _onToggleReaction(ForumReaction r) {
    final was = _selected.contains(r);
    setState(() {
      if (was) {
        _selected.remove(r);
        _counts[r] = (_counts[r] ?? 0) - 1;
        if (_counts[r]! < 0) _counts[r] = 0;
      } else {
        _selected.add(r);
        _counts[r] = (_counts[r] ?? 0) + 1;
      }
    });

    // TODO(API): 서버 요청 & 실패 시 롤백
    // try { await api.setReaction(postId: widget.detail.id, type: r, enable: !was); }
    // catch (_) { setState(() { ...롤백... }); }
  }

  void _onSendComment() {
    final t = _commentInput.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _comments.insert(
        0,
        PostComment(
          id: DateTime.now().microsecondsSinceEpoch,
          user: '나',
          date: DateTime.now(),
          text: t,
          likes: 0,
        ),
      );
      _commentInput.clear();
    });
    _toast('댓글을 남겼습니다.');
  }

  void _scrollToComments() {
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  // ---- UI ----
  @override
  Widget build(BuildContext context) {
    final d = widget.detail;

    return Scaffold(
      appBar: SaeipAppBar(
        actions: [
          IconButton(
            // 북마크 토글
            icon: SvgPicture.asset(
              _bookmarked ? 'assets/icons/bookmark_green_filled.svg' : 'assets/icons/bookmark_green_border.svg',
              height:20.h,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      bottomNavigationBar: _PostCommentInputBar(
        controller: _commentInput,
        onSend: _onSendComment,
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scroll,
          slivers: [
            // 상단(헤더/제목/메타/이미지/본문/리액션)
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  PostDetailHeader(
                    categoryName: d.category.name,
                    orgName: d.relatedOrganization,
                    authorNickname: d.authorNickname,
                    createdAt: d.createdAt,
                    viewCount: d.viewCount,
                  ),
                  Gap(8.h),
                  Text(d.title, style: AppTextStyles.titleSemibold(context)),
                  Gap(6.h),
                  _PostMetaRow(
                    date: d.createdAt,
                    views: d.viewCount,
                    comments: d.commentCount,
                    scraps: 0,
                  ),
                  const Divider(height: 24),
                  if (d.images.isNotEmpty) ...[
                    _ImagesCarousel(urls: d.images.map((e) => e.s3Url).toList()),
                    Gap(16.h),
                  ],
                  _PostContent(content: d.content),
                  const Divider(height: 24),

                  // ✅ 부모가 가진 상태를 내려줌
                  PostDetailReactions(
                    counts: _counts,
                    selected: _selected,
                    onToggle: _onToggleReaction,
                  ),
                  Gap(12.h),
                ]),
              ),
            ),

            // 댓글 영역
            if (_comments.isEmpty)
              SliverFillRemaining(hasScrollBody: false, child: _EmptyComments())
            else
              PostDetailComments(
                comments: _comments,
                onTapMore: (c) => _showCommentMenu(c),
                onTapLike: (c) => setState(() => c.likes++),
              ),

            // 입력바 공간 확보
            SliverToBoxAdapter(child: Gap(80.h)),
          ],
        ),
      ),
    );
  }

  Future<void> _showCommentMenu(PostComment c) async {
    final action = await showModalBottomSheet<_CommentAction>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('대댓글 알림 켜기'),
              onTap: () => Navigator.pop(context, _CommentAction.notify),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('댓글 수정'),
              onTap: () => Navigator.pop(context, _CommentAction.edit),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('댓글 삭제'),
              onTap: () => Navigator.pop(context, _CommentAction.delete),
            ),
          ],
        ),
      ),
    );

    switch (action) {
      case _CommentAction.notify:
        _toast('대댓글 알림을 켰습니다.');
        break;
      case _CommentAction.edit:
        _toast('댓글 수정은 다음 버전에 제공됩니다.');
        break;
      case _CommentAction.delete:
        final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('댓글을 삭제할까요?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('취소')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('삭제')),
            ],
          ),
        );
        if (ok == true) {
          setState(() => _comments.removeWhere((e) => e.id == c.id));
          _toast('댓글을 삭제했습니다.');
        }
        break;
      default:
        break;
    }
  }
}

class _PostMetaRow extends StatelessWidget {
  const _PostMetaRow({
    required this.date,
    required this.views,
    required this.scraps,
    required this.comments,
  });

  final DateTime date;
  final int views;
  final int scraps;
  final int comments;

  @override
  Widget build(BuildContext context) {
    final d = '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}.';
    final sub = AppTextStyles.smallMedium(context);

    Widget iconText(IconData i, String t) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(i, size: 16.sp, color: AppColors.blackBlack3), Gap(4.w), Text(t, style: sub)],
        );

    return Row(
      children: [
        Text(d, style: sub),
        const Spacer(),
        iconText(Icons.visibility, views.toString()),
        Gap(12.w),
        iconText(Icons.comment, comments.toString()),
        Gap(12.w),
        iconText(Icons.bookmarks_outlined, scraps.toString()),
      ],
    );
  }
}

class _ImagesCarousel extends StatefulWidget {
  const _ImagesCarousel({required this.urls});
  final List<String> urls;

  @override
  State<_ImagesCarousel> createState() => _ImagesCarouselState();
}

class _ImagesCarouselState extends State<_ImagesCarousel> {
  final PageController _page = PageController();
  int _index = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.urls.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: PageView.builder(
            controller: _page,
            itemCount: widget.urls.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(widget.urls[i], fit: BoxFit.cover),
            ),
          ),
        ),
        Gap(8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.urls.length,
            (i) => Container(
              width: 6.w,
              height: 6.w,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _index ? AppColors.blackBlack3 : AppColors.blackBlack1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PostContent extends StatelessWidget {
  const _PostContent({required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    final paragraphs = content.split('\n\n').where((e) => e.trim().isNotEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs
          .map((p) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Text(p, style: AppTextStyles.bodyRegular(context)),
              ))
          .toList(),
    );
  }
}

class _EmptyComments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SvgPicture.asset('assets/icons/comment_empty.svg', width: 88.w, height: 88.w, fit: BoxFit.contain),
        Gap(12.h),
        Text('첫 댓글을 남겨주세요.', style: AppTextStyles.bodyRegular(context).copyWith(color: AppColors.blackBlack4)),
      ]),
    );
  }
}

// 하단 입력바
class _PostCommentInputBar extends StatelessWidget {
  const _PostCommentInputBar({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 12.w, 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.blackBlack1, width: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: '마음 속 이야기를 공유해요.',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(onPressed: onSend, icon: const Icon(Icons.send), splashRadius: 22.w),
          ],
        ),
      ),
    );
  }
}

// 댓글 로컬 모델 & 메뉴 액션
class PostComment {
  PostComment({
    required this.id,
    required this.user,
    required this.date,
    required this.text,
    required this.likes,
  });
  final int id;
  final String user;
  final DateTime date;
  final String text;
  int likes;
}

enum _CommentAction { notify, edit, delete }
