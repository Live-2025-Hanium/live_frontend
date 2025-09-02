import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/forum_post_model.dart';
import '../screens/forum/widgets/sort_controls.dart';
import '../screens/forum/data/dummy_forum_data.dart';

final forumSearchProvider =
    StateNotifierProvider<ForumSearchNotifier, ForumSearchState>((ref) {
  return ForumSearchNotifier();
});

class ForumSearchState {
  final String query;
  final bool loading;
  final bool loadingMore;
  final Object? error;
  final List<ForumPostModel> items;
  final ForumSort sort;
  final bool hasMore;

  const ForumSearchState({
    this.query = '',
    this.loading = false,
    this.loadingMore = false,
    this.error,
    this.items = const [],
    this.sort = ForumSort.latest,
    this.hasMore = false,
  });

  ForumSearchState copyWith({
    String? query,
    bool? loading,
    bool? loadingMore,
    Object? error,
    List<ForumPostModel>? items,
    ForumSort? sort,
    bool? hasMore,
  }) {
    return ForumSearchState(
      query: query ?? this.query,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: error ?? this.error,
      items: items ?? this.items,
      sort: sort ?? this.sort,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ForumSearchNotifier extends StateNotifier<ForumSearchState> {
  ForumSearchNotifier() : super(const ForumSearchState());

  final List<ForumPostModel> _all = [];
  static const int _pageSize = 6;

  void reset() {
    _all.clear();
    state = const ForumSearchState();
  }

  Future<void> searchFirst(String raw) async {
    final query = raw.trim();
    if (query.isEmpty) {
      reset();
      return;
    }

    state = state.copyWith(
      query: query,
      loading: true,
      error: null,
      items: const [],
      hasMore: false,
    );

    try {
      // TODO: 나중에 API 연동 시 수정
      await Future.delayed(const Duration(milliseconds: 300));
      
      _all
        ..clear()
        ..addAll(_filterByQuery(dummyForumPosts, query));
      _sortInPlace(_all, state.sort);
      
      final slice = _all.take(_pageSize).toList();
      state = state.copyWith(
        loading: false,
        items: slice,
        hasMore: _all.length > slice.length,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }

  void setSort(ForumSort sort) {
    state = state.copyWith(sort: sort);
    // 정렬을 바꾸면 _all을 다시 정렬하고 첫 페이지 다시 적용
    _sortInPlace(_all, sort);
    final slice = _all.take(_pageSize).toList();
    state = state.copyWith(
      items: slice,
      hasMore: _all.length > slice.length,
    );
  }

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasMore) return;

    state = state.copyWith(loadingMore: true);
    try {
      await Future.delayed(const Duration(milliseconds: 250)); // mock delay

      final cur = state.items.length;
      final end = (cur + _pageSize).clamp(0, _all.length);
      final more = _all.sublist(cur, end);

      final next = [...state.items, ...more];
      state = state.copyWith(
        loadingMore: false,
        items: next,
        hasMore: _all.length > next.length,
      );
    } catch (_) {
      state = state.copyWith(loadingMore: false);
    }
  }

  // helpers
  List<ForumPostModel> _filterByQuery(List<ForumPostModel> src, String q) {
    final lower = q.toLowerCase();
    return src.where((p) {
      return p.title.toLowerCase().contains(lower) ||
          p.relatedOrganization.toLowerCase().contains(lower) ||
          (p.authorNickname?.toLowerCase().contains(lower) ?? false);
    }).toList();
  }

  void _sortInPlace(List<ForumPostModel> list, ForumSort sort) {
    switch (sort) {
      case ForumSort.latest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case ForumSort.views:
        list.sort((a, b) => (b.viewCount ?? 0).compareTo(a.viewCount ?? 0));
        break;
      case ForumSort.scraps:
        list.sort(
            (a, b) => (b.totalReactionCount ?? 0).compareTo(a.totalReactionCount ?? 0));
        break;
    }
  }
}
