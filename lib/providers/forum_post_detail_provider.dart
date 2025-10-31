// lib/providers/forum_post_detail_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:live_frontend/models/forum_post_detail_model.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/providers/dio_provider.dart';

/// 상세 조회: /api/v1/boards/{boardId}
final postDetailProvider = FutureProvider.family<ForumPostDetailModel, int>((
  ref,
  boardId,
) async {
  final dio = ref.read(dioProvider);

  try {
    final resp = await dio.get('/api/v1/boards/$boardId');

    final parsed = ApiResponseModel<ForumPostDetailModel>.fromJson(
      resp.data as Map<String, dynamic>,
      (raw) => ForumPostDetailModel.fromJson(raw as Map<String, dynamic>),
    );

    final data = parsed.data;
    if (data == null) throw StateError('Empty data for boardId=$boardId');
    return data;
  } on DioException catch (e, st) {
    debugPrint('postDetailProvider DioException: ${e.message}');
    Error.throwWithStackTrace(e, st);
  }
});

@immutable
class ForumPostDetailState {
  const ForumPostDetailState({
    required this.detail,
    required this.isBookmarked,
    required this.reactions,
    required this.selectedReactions,
  });

  final ForumPostDetailModel? detail;
  final bool isBookmarked;
  final Map<ReactionType, int> reactions;
  final Set<ReactionType> selectedReactions;

  factory ForumPostDetailState.initial() => const ForumPostDetailState(
    detail: null,
    isBookmarked: false,
    reactions: <ReactionType, int>{},
    selectedReactions: <ReactionType>{},
  );

  ForumPostDetailState copyWith({
    ForumPostDetailModel? detail,
    bool? isBookmarked,
    Map<ReactionType, int>? reactions,
    Set<ReactionType>? selectedReactions,
  }) {
    return ForumPostDetailState(
      detail: detail ?? this.detail,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      reactions: reactions ?? this.reactions,
      selectedReactions: selectedReactions ?? this.selectedReactions,
    );
  }
}

class ForumPostDetailNotifier extends StateNotifier<ForumPostDetailState> {
  ForumPostDetailNotifier(this._dio, this._boardId)
    : super(ForumPostDetailState.initial());

  final Dio _dio;
  final int _boardId;

  /// 서버 모델로 상태 시드
  void seed(ForumPostDetailModel detail) {
    state = state.copyWith(
      detail: detail,
      isBookmarked: detail.scraped,
      reactions: detail.reactionCounts,
      selectedReactions: detail.userReactions,
    );
  }

  /// 스크랩 토글 (POST /api/v1/scraps/boards/{boardId}/toggle)
  /// 낙관적 업데이트 + 실패 시 롤백
  Future<void> toggleBookmark() async {
    final prev = state;
    state = state.copyWith(isBookmarked: !state.isBookmarked);

    try {
      await _dio.post('/api/v1/scraps/boards/$_boardId/toggle');
    } catch (e) {
      state = prev; // 롤백
      rethrow;
    }
  }

  /// 리액션 토글 (POST /api/v1/boards/{boardId}/reactions {type})
  /// 낙관적 업데이트 + 실패 시 롤백
  Future<void> toggleReaction(ReactionType reaction) async {
    // UNKNOWN은 전송/토글 대상이 아님
    if (reaction == ReactionType.unknown) return;

    final prev = state;

    final newSelected = {...state.selectedReactions};
    final newCounts = {...state.reactions};

    final picked = newSelected.contains(reaction);
    if (picked) {
      newSelected.remove(reaction);
      newCounts[reaction] = (newCounts[reaction] ?? 0) - 1;
      if ((newCounts[reaction] ?? 0) < 0) newCounts[reaction] = 0;
    } else {
      newSelected.add(reaction);
      newCounts[reaction] = (newCounts[reaction] ?? 0) + 1;
    }
    state = state.copyWith(
      reactions: newCounts,
      selectedReactions: newSelected,
    );

    try {
      await _dio.post(
        '/api/v1/boards/$_boardId/reactions',
        data: {'type': reaction.serverValue}, // ✅ 공개 헬퍼 사용
      );
    } catch (e) {
      state = prev; // 롤백
      // rethrow;
    }
  }
}

final forumPostDetailProvider =
    StateNotifierProvider.family<
      ForumPostDetailNotifier,
      ForumPostDetailState,
      int
    >((ref, boardId) {
      final dio = ref.watch(dioProvider);
      final notifier = ForumPostDetailNotifier(dio, boardId);

      // 최초 시드
      final cur = ref.read(postDetailProvider(boardId));
      if (cur.hasValue) notifier.seed(cur.value!);

      // 새로고침/리로드에 대응
      ref.listen(postDetailProvider(boardId), (_, next) {
        next.whenData(notifier.seed);
      });

      return notifier;
    });
