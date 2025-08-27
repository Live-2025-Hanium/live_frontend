// lib/providers/forum_post_detail_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:live_frontend/models/forum_post_detail_model.dart';
import 'package:live_frontend/models/forum_post_comment_model.dart';
import 'package:live_frontend/screens/forum/data/dummy_comments.dart';
import 'package:live_frontend/screens/forum/data/dummy_post_detail.dart';
import 'package:live_frontend/screens/forum/widgets/post_detail_reaction.dart';

/// ----- 상세 조회(Mock) -----
final postDetailProvider = FutureProvider.family<PostDetail, int>((ref, id) async {
  await Future.delayed(const Duration(milliseconds: 200)); // mock delay
  if (id == 1) return mockPostDetail;
  // TODO: API 연동
  throw Exception('모킹 단계: id=1만 지원합니다.');
});

/// 전역 navigatorKey 제공(있으면 토스트/모달에 사용)
final navigatorKeyProvider = Provider((ref) => GlobalKey<NavigatorState>());

/// ----- 상태 -----
class ForumPostState {
  const ForumPostState({
    required this.detail,
    required this.isBookmarked,
    required this.reactions,
    required this.selectedReactions,
    required this.comments,
  });

  /// 시딩 전에는 null
  final PostDetail? detail;
  final bool isBookmarked;
  final Map<ForumReaction, int> reactions;
  final Set<ForumReaction> selectedReactions;
  final List<ForumPostComment> comments;

  factory ForumPostState.initial() => const ForumPostState(
        detail: null,
        isBookmarked: false,
        reactions: <ForumReaction, int>{},
        selectedReactions: <ForumReaction>{},
        comments: <ForumPostComment>[],
      );

  ForumPostState copyWith({
    PostDetail? detail,
    bool? isBookmarked,
    Map<ForumReaction, int>? reactions,
    Set<ForumReaction>? selectedReactions,
    List<ForumPostComment>? comments,
  }) {
    return ForumPostState(
      detail: detail ?? this.detail,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      reactions: reactions ?? this.reactions,
      selectedReactions: selectedReactions ?? this.selectedReactions,
      comments: comments ?? this.comments,
    );
  }
}

enum CommentAction { notify, edit, delete }

/// ----- Notifier -----
class ForumPostNotifier extends StateNotifier<ForumPostState> {
  ForumPostNotifier({this.navigatorContext})
      : super(ForumPostState.initial());

  final BuildContext? navigatorContext;

  /// 상세가 준비된 뒤 호출되어 상태를 시딩
  void seed(PostDetail detail) {
    state = ForumPostState(
      detail: detail,
      isBookmarked: false,
      reactions: _initReactions(detail),
      selectedReactions: _initSelectedReactions(detail),
      comments: List.of(dummyComments),
    );
  }

  static Map<ForumReaction, int> _initReactions(PostDetail d) => {
        ForumReaction.useful: 0,
        ForumReaction.encourage: 0,
        ForumReaction.willTry: 0,
        ForumReaction.empathy: d.reactionCounts[ReactionType.empathy] ?? 0,
        ForumReaction.thanks: 0,
      };

  static Set<ForumReaction> _initSelectedReactions(PostDetail d) {
    final selected = <ForumReaction>{};
    if (d.userReactions.contains(ReactionType.empathy)) {
      selected.add(ForumReaction.empathy);
    }
    return selected;
  }

  void toggleBookmark() {
    state = state.copyWith(isBookmarked: !state.isBookmarked);
  }

  void toggleReaction(ForumReaction reaction) {
    final selected = Set.of(state.selectedReactions);
    final counts = Map.of(state.reactions);

    if (selected.contains(reaction)) {
      selected.remove(reaction);
      counts[reaction] = (counts[reaction] ?? 0) - 1;
      if ((counts[reaction] ?? 0) < 0) counts[reaction] = 0;
    } else {
      selected.add(reaction);
      counts[reaction] = (counts[reaction] ?? 0) + 1;
    }

    state = state.copyWith(reactions: counts, selectedReactions: selected);
    // TODO: API 연동 시 실패 롤백
  }

  void addComment(String content) {
    final t = content.trim();
    if (t.isEmpty) return;

    final now = DateTime.now();
    final newComment = ForumPostComment(
      id: now.microsecondsSinceEpoch,
      content: t,
      authorNickname: '나',
      createdAt: now,
      updatedAt: now,
      likeCount: 0,
      isLiked: false,
      isMyComment: true,
      replies: const [],
    );

    state = state.copyWith(comments: [newComment, ...state.comments]);
    _showToast('댓글을 남겼습니다.');
  }

  void toggleCommentLike(int commentId) {
    final comments = [...state.comments];
    final i = comments.indexWhere((c) => c.id == commentId);
    if (i == -1) return;

    final c = comments[i];
    comments[i] = c.copyWith(
      isLiked: !c.isLiked,
      likeCount: c.likeCount + (c.isLiked ? -1 : 1),
    );
    state = state.copyWith(comments: comments);
  }

  void deleteComment(int commentId) {
    state = state.copyWith(
      comments: [
        for (final c in state.comments)
          if (c.id != commentId) c,
      ],
    );
    _showToast('댓글을 삭제했습니다.');
  }

  void likeComment(ForumPostComment comment) {
    toggleCommentLike(comment.id);
  }

  Future<void> showCommentMenu(ForumPostComment comment) async {
    final ctx = navigatorContext;
    if (ctx == null) return;

    final action = await showModalBottomSheet<CommentAction>(
      context: ctx,
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
              onTap: () => Navigator.pop(ctx, CommentAction.notify),
            ),
            if (comment.isMyComment) ...[
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('댓글 수정'),
                onTap: () => Navigator.pop(ctx, CommentAction.edit),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('댓글 삭제'),
                onTap: () => Navigator.pop(ctx, CommentAction.delete),
              ),
            ],
          ],
        ),
      ),
    );

    switch (action) {
      case CommentAction.notify:
        _showToast('대댓글 알림을 켰습니다.');
        break;
      case CommentAction.edit:
        _showToast('댓글 수정은 다음 버전에 제공됩니다.');
        break;
      case CommentAction.delete:
        final ok = await showDialog<bool>(
          context: ctx,
          builder: (_) => AlertDialog(
            title: const Text('댓글을 삭제할까요?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('삭제')),
            ],
          ),
        );
        if (ok == true) deleteComment(comment.id);
        break;
      default:
        break;
    }
  }

  void _showToast(String message) {
    final ctx = navigatorContext;
    if (ctx == null) return;
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

/// ----- 화면용 Provider (null-safe 시딩) -----
final forumPostProvider =
    StateNotifierProvider.family<ForumPostNotifier, ForumPostState, int>(
  (ref, postId) {
    final navCtx = ref.read(navigatorKeyProvider).currentContext;
    final notifier = ForumPostNotifier(navigatorContext: navCtx);

    // 1) 현재 값이 이미 준비되어 있으면 즉시 시딩
    final cur = ref.read(postDetailProvider(postId));
    if (cur.hasValue) {
      notifier.seed(cur.value!);
    }

    // 2) 이후 로딩 완료될 때마다 갱신
    ref.listen(postDetailProvider(postId), (prev, next) {
      next.whenData(notifier.seed);
    });

    return notifier;
  },
);
