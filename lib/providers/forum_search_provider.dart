import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/forum_post_model.dart';
import '../screens/forum/widgets/sort_controls.dart';

final forumSearchProvider = StateNotifierProvider<ForumSearchNotifier, ForumSearchState>((ref) {
  return ForumSearchNotifier();
});

class ForumSearchState {
  final String query;
  final bool loading;
  final bool loadingMore;
  final Object? error;
  final List<ForumPost> items;
  final String? nextCursor;
  final ForumSort sort;

  const ForumSearchState({
    this.query = '',
    this.loading = false,
    this.loadingMore = false,
    this.error,
    this.items = const [],
    this.nextCursor,
    this.sort = ForumSort.latest,
  });

  ForumSearchState copyWith({
    String? query,
    bool? loading,
    bool? loadingMore,
    Object? error,
    List<ForumPost>? items,
    String? nextCursor,
    ForumSort? sort,
  }) {
    return ForumSearchState(
      query: query ?? this.query,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: error ?? this.error,
      items: items ?? this.items,
      nextCursor: nextCursor ?? this.nextCursor,
      sort: sort ?? this.sort,
    );
  }
}

class ForumSearchNotifier extends StateNotifier<ForumSearchState> {
  ForumSearchNotifier() : super(const ForumSearchState());

  void setSort(ForumSort sort) {
    state = state.copyWith(sort: sort);
    searchFirst(state.query);
  }

  void reset() {
    state = ForumSearchState();  // 상태를 초기 상태로 리셋
  }

  Future<void> searchFirst(String query) async {
    state = state.copyWith(
      query: query,
      loading: true,
      error: null,
      items: [],
      nextCursor: null,
    );

    try {
      final res = await _searchBoards(query: query);
      state = state.copyWith(
        items: res.items,
        nextCursor: res.nextCursor,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e, loading: false);
    }
  }

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || state.nextCursor == null) return;

    state = state.copyWith(loadingMore: true);

    try {
      final res = await _searchBoards(query: state.query, cursor: state.nextCursor);
      state = state.copyWith(
        items: [...state.items, ...res.items],
        nextCursor: res.nextCursor,
        loadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(loadingMore: false);
    }
  }

  Future<SearchResult> _searchBoards({
    required String query,
    String? cursor,
  }) async {
    await Future.delayed(const Duration(milliseconds: 450));
    return SearchResult(items: [], nextCursor: null);
  }
}

class SearchResult {
  final List<ForumPost> items;
  final String? nextCursor;
  SearchResult({required this.items, required this.nextCursor});
}