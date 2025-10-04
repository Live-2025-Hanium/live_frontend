import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:live_frontend/models/forum_post_comment_model.dart';
import 'package:live_frontend/models/common_api_response_model.dart';

final commentsApiClientProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: '', // TODO: baseUrl
      headers: {'Content-Type': 'application/json'},
    ),
  );
});

@immutable
class CommentsState {
  final List<ForumPostCommentModel> roots;
  final bool loading;
  final bool loadingMore;
  final Object? error;
  final bool hasNext;
  final int? nextCursor;
  final ForumPostCommentModel? replyTo;

  const CommentsState({
    this.roots = const [],
    this.loading = false,
    this.loadingMore = false,
    this.error,
    this.hasNext = true,
    this.nextCursor,
    this.replyTo,
  });

  CommentsState copyWith({
    List<ForumPostCommentModel>? roots,
    bool? loading,
    bool? loadingMore,
    Object? error,
    bool? hasNext,
    int? nextCursor,
    ForumPostCommentModel? replyTo,
  }) {
    return CommentsState(
      roots: roots ?? this.roots,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: error ?? this.error,
      hasNext: hasNext ?? this.hasNext,
      nextCursor: nextCursor ?? this.nextCursor,
      replyTo: replyTo ?? this.replyTo,
    );
  }
}

final postCommentsProvider =
    StateNotifierProvider.family<PostCommentsController, CommentsState, int>((
      ref,
      postId,
    ) {
      final dio = ref.watch(commentsApiClientProvider);
      final ctrl = PostCommentsController(dio: dio, postId: postId);
      Future.microtask(ctrl.reload);
      return ctrl;
    });

class PostCommentsController extends StateNotifier<CommentsState> {
  PostCommentsController({required Dio dio, required this.postId})
    : _dio = dio,
      super(const CommentsState());

  final Dio _dio;
  final int postId;

  Future<void> reload() async {
    state = state.copyWith(loading: true);
    await Future.delayed(const Duration(milliseconds: 100));
    state = state.copyWith(loading: false, roots: []);
  }

  Future<void> addComment(String text) async {
    final now = DateTime.now();
    final optimistic = ForumPostCommentModel(
      id: now.microsecondsSinceEpoch,
      content: text,
      authorNickname: 'me',
      createdAt: now,
      updatedAt: now,
      likeCount: 0,
      isLiked: false,
      isMyComment: true,
      replies: const [],
    );
    state = state.copyWith(roots: [optimistic, ...state.roots]);
    try {
      // TODO: POST /api/boards/{postId}/comments
    } catch (_) {
      // 실패 시 롤백
    }
  }

  Future<void> addReply(int parentId, String text) async {
    // TODO: POST /api/boards/{postId}/comments/{parentId}/replies
  }

  void startReply(ForumPostCommentModel target) {
    state = state.copyWith(replyTo: target);
  }

  void cancelReply() {
    state = state.copyWith(replyTo: null);
  }

  void toggleLike(int commentId) {
    final roots = [...state.roots];
    final updatedRoots = roots.map((c) {
      if (c.id == commentId) {
        return c.copyWith(
          isLiked: !c.isLiked,
          likeCount: c.isLiked ? c.likeCount - 1 : c.likeCount + 1,
        );
      }
      // 대댓글 트리 안에서도 찾아야 함
      final updatedReplies = c.replies
          ?.map(
            (r) => r.id == commentId
                ? r.copyWith(
                    isLiked: !r.isLiked,
                    likeCount: r.isLiked ? r.likeCount - 1 : r.likeCount + 1,
                  )
                : r,
          )
          .toList();
      return c.copyWith(replies: updatedReplies ?? c.replies);
    }).toList();

    state = state.copyWith(roots: updatedRoots);

    // TODO: 서버에 좋아요 API 호출 (성공/실패 시 동기화)
  }
}

/// copyWith 확장 (댓글 트리 조작용)
extension ForumPostCommentModelCopy on ForumPostCommentModel {
  ForumPostCommentModel copyWith({
    int? id,
    String? content,
    String? authorNickname,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likeCount,
    bool? isLiked,
    bool? isMyComment,
    List<ForumPostCommentModel>? replies,
  }) {
    return ForumPostCommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      authorNickname: authorNickname ?? this.authorNickname,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isMyComment: isMyComment ?? this.isMyComment,
      replies: replies ?? this.replies,
    );
  }
}
