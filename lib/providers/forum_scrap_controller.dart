// lib/providers/scrap_controller.dart
import 'package:flutter/foundation.dart' as flutter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:live_frontend/models/forum_post_model.dart';
import 'package:live_frontend/models/common_api_response_model.dart';
import 'package:live_frontend/providers/dio_provider.dart';

/// 공통 API 에러로 변환
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}

/// ---------- 응답 data DTO (ApiResponseModel<T>의 T) ----------
class ScrapListData {
  final bool hasNext;
  final int? nextCursor;
  final List<ForumPostModel> content;
  ScrapListData({required this.hasNext, required this.nextCursor, required this.content});

  factory ScrapListData.fromJson(Object? json) {
    final map = json as Map<String, dynamic>;
    final raw = (map['content'] as List<dynamic>? ?? const []);
    final posts = raw.map<ForumPostModel>((e) {
      final m = e as Map<String, dynamic>;
      final cat = m['category'] as Map<String, dynamic>?;
      final category = Category(
        id: (cat?['id'] as num?)?.toInt() ?? 0,
        name: (cat?['name'] as String?) ?? '기타',
      );
      return ForumPostModel(
        id: (m['id'] as num).toInt(),
        title: m['title'] as String,
        category: category,
        relatedOrganization: (m['relatedOrganization'] as String?) ?? '',
        createdAt: DateTime.parse(m['createdAt'] as String),
        thumbnailImageUrl: (m['thumbnailImageUrl'] as String?)?.trim().isEmpty == true
            ? null
            : m['thumbnailImageUrl'] as String?,
        authorNickname: m['authorNickname'] as String?,
        viewCount: (m['viewCount'] as num?)?.toInt(),
        totalReactionCount: (m['totalReactionCount'] as num?)?.toInt(),
      );
    }).toList();
    return ScrapListData(
      hasNext: map['hasNext'] as bool? ?? false,
      nextCursor: (map['nextCursor'] as num?)?.toInt(),
      content: posts,
    );
  }
}

class ToggleScrapData {
  final bool isScraped;
  final String? message;
  ToggleScrapData({required this.isScraped, this.message});
  factory ToggleScrapData.fromJson(Object? json) {
    final m = json as Map<String, dynamic>;
    return ToggleScrapData(
      isScraped: m['isScraped'] as bool? ?? false,
      message: m['message'] as String?,
    );
  }
}

/// ---------- State ----------
@flutter.immutable
class ScrapState {
  final List<ForumPostModel> items;
  final bool loading;
  final bool loadingMore;
  final Object? error;
  final int? nextCursor; // 커서 페이징
  final bool hasNext;

  final bool editing; // 편집 모드
  final Set<int> selected; // 선택된 게시글 id
  final bool acting; // 해제 API 진행중

  const ScrapState({
    this.items = const [],
    this.loading = false,
    this.loadingMore = false,
    this.error,
    this.nextCursor,
    this.hasNext = true,
    this.editing = false,
    this.selected = const {},
    this.acting = false,
  });

  ScrapState copyWith({
    List<ForumPostModel>? items,
    bool? loading,
    bool? loadingMore,
    Object? error = _noChange,
    Object? nextCursor = _keepCursor,
    bool? hasNext,
    bool? editing,
    Set<int>? selected,
    bool? acting,
  }) {
    return ScrapState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: identical(error, _noChange) ? this.error : error,
      nextCursor: identical(nextCursor, _keepCursor) ? this.nextCursor : nextCursor as int?,
      hasNext: hasNext ?? this.hasNext,
      editing: editing ?? this.editing,
      selected: selected ?? this.selected,
      acting: acting ?? this.acting,
    );
  }

  static const _noChange = Object();
  static const _keepCursor = Object();
}

/// ---------- Controller (Notifier + API 호출) ----------
class ScrapNotifier extends StateNotifier<ScrapState> {
  ScrapNotifier(this._dio) : super(const ScrapState());
  final Dio _dio;

  static const int _pageSize = 20;

  Future<void> reload() async {
    state = state.copyWith(loading: true, error: null, nextCursor: null, hasNext: true);
    try {
      final data = await _apiGetScraps(cursorId: null, size: _pageSize);
      state = state.copyWith(
        items: data.content,
        loading: false,
        nextCursor: data.nextCursor,
        hasNext: data.hasNext,
        selected: {},
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (state.loading || state.loadingMore || !state.hasNext) return;
    state = state.copyWith(loadingMore: true);
    try {
      final data = await _apiGetScraps(cursorId: state.nextCursor, size: _pageSize);

      // id 기반 디듀프(안전장치)
      final map = {for (final p in state.items) p.id: p};
      for (final p in data.content) map[p.id] = p;

      state = state.copyWith(
        items: map.values.toList(),
        loadingMore: false,
        nextCursor: data.nextCursor,
        hasNext: data.hasNext && data.nextCursor != null,
      );
    } catch (e) {
      state = state.copyWith(loadingMore: false, error: e);
    }
  }

  void toggleEdit() {
    final editing = !state.editing;
    state = state.copyWith(editing: editing);
    if (!editing) state = state.copyWith(selected: {});
  }

  void toggleSelect(int id) {
    if (!state.editing) return;
    final s = Set<int>.from(state.selected);
    s.contains(id) ? s.remove(id) : s.add(id);
    state = state.copyWith(selected: s);
  }

  /// 낙관적 UI: 먼저 제거 → 실패 시 롤백
  Future<void> unScrapSelected() async {
    if (state.selected.isEmpty) return;

    final removedIds = state.selected.toList(growable: false);
    final backupItems = state.items;

    final optimistic = backupItems.where((p) => !state.selected.contains(p.id)).toList();
    state = state.copyWith(items: optimistic, selected: {}, acting: true);

    try {
      await _apiDeleteMany(removedIds);
      state = state.copyWith(acting: false);
    } catch (e) {
      state = state.copyWith(items: backupItems, selected: removedIds.toSet(), acting: false, error: e);
      rethrow;
    }
  }

  // ============================
  // 아래는 동일 파일 내 API 연동부 (ApiResponseModel<T> 사용)
  // ============================

  Future<ScrapListData> _apiGetScraps({int? cursorId, required int size}) async {
    final res = await _dio.get('/api/v1/scraps', queryParameters: {
      if (cursorId != null) 'cursorId': cursorId,
      'size': size.clamp(1, 100),
    });

    if (res.data is! Map<String, dynamic>) {
      throw ApiException('잘못된 응답 포맷입니다.');
    }

    final parsed = ApiResponseModel<ScrapListData>.fromJson(
      res.data as Map<String, dynamic>,
      (obj) => ScrapListData.fromJson(obj),
    );

    if (!parsed.success) {
      final msg = parsed.error?.message ?? parsed.message;
      throw ApiException(msg);
    }
    return parsed.data ?? ScrapListData(hasNext: false, nextCursor: null, content: const []);
  }

  Future<void> _apiDeleteMany(List<int> ids) async {
    final res = await _dio.delete('/api/v1/scraps/boards', data: {'boardIds': ids});
    if (res.data is! Map<String, dynamic>) {
      throw ApiException('잘못된 응답 포맷입니다.');
    }
    final parsed = ApiResponseModel<Map<String, dynamic>>.fromJson(
      res.data as Map<String, dynamic>,
      (obj) => (obj as Map<String, dynamic>?) ?? <String, dynamic>{},
    );
    if (!parsed.success) {
      final msg = parsed.error?.message ?? parsed.message;
      throw ApiException(msg);
    }
    // 필요하면 parsed.data['deletedCount'] 등을 사용할 수 있음
  }

  Future<bool> toggleScrap(int boardId) async {
    final res = await _dio.post('/api/v1/scraps/boards/$boardId/toggle');

    if (res.data is! Map<String, dynamic>) {
      throw ApiException('잘못된 응답 포맷입니다.');
    }

    final parsed = ApiResponseModel<ToggleScrapData>.fromJson(
      res.data as Map<String, dynamic>,
      (obj) => ToggleScrapData.fromJson(obj),
    );

    if (!parsed.success) {
      final msg = parsed.error?.message ?? parsed.message;
      throw ApiException(msg);
    }
    return parsed.data?.isScraped ?? false;
  }
}

final scrapControllerProvider =
    StateNotifierProvider<ScrapNotifier, ScrapState>((ref) {
  final dio = ref.read(dioProvider);;
  final notifier = ScrapNotifier(dio);
  Future.microtask(() => notifier.reload());
  return notifier;
});
