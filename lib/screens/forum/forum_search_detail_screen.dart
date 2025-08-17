import 'package:flutter/material.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'package:live_frontend/widgets/utils/debouncer.dart';
import 'package:live_frontend/widgets/utils/recent_search_repo.dart';

class ForumSearchDetailScreen extends StatefulWidget {
  const ForumSearchDetailScreen({
    super.key,
    required this.externalController,
    required this.hintText,
  });

  final TextEditingController externalController;
  final String hintText;

  @override
  State<ForumSearchDetailScreen> createState() => _ForumSearchDetailScreenState();
}

class _ForumSearchDetailScreenState extends State<ForumSearchDetailScreen> {
  static const int _maxRecent = 10;

  late final TextEditingController _controller = widget.externalController;
  late final Debouncer _debouncer = Debouncer(milliseconds: 250);
  final ScrollController _scroll = ScrollController();

  // ===== State (Recent) =====
  List<String> _recent = const [];
  bool _recentLoading = true;
  Object? _recentError;

  // ===== State (Search) =====
  String _query = '';
  bool _loading = false;       // 첫 페이지 로딩
  bool _loadingMore = false;   // 추가 로딩
  Object? _error;
  String? _nextCursor;
  final List<_BoardItem> _items = [];

  // ===== Data source (주입 가능 구조) =====
  final _BoardSearchDataSource _dataSource = _BoardSearchDataSource();

  // ===== Lifecycle =====
  @override
  void initState() {
    super.initState();
    _loadRecent();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // ===== Recent Ops =====
  Future<void> _loadRecent() async {
    setState(() {
      _recentLoading = true;
      _recentError = null;
    });
    try {
      final data = await RecentSearchRepo.fetchAll();
      if (!mounted) return;
      setState(() {
        _recent = data;
        _recentLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _recentError = e;
        _recentLoading = false;
      });
    }
  }

  Future<void> _saveRecent(String term) async {
    await RecentSearchRepo.upsert(term, max: _maxRecent);
    await _loadRecent();
  }

  Future<void> _removeRecent(String term) async {
    await RecentSearchRepo.remove(term);
    await _loadRecent();
  }

  Future<void> _clearRecent() async {
    await RecentSearchRepo.clear();
    await _loadRecent();
  }

  // ===== Search Ops =====
  Future<void> _searchFirst(String q) async {
    setState(() {
      _query = q;
      _loading = true;
      _error = null;
      _items.clear();
      _nextCursor = null;
    });

    try {
      final res = await _dataSource.searchBoards(query: q, cursor: null);
      if (!mounted) return;
      setState(() {
        _items.addAll(res.items);
        _nextCursor = res.nextCursor;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _searchMore() async {
    if (_loading || _loadingMore) return;
    if (_nextCursor == null) return;

    setState(() => _loadingMore = true);
    try {
      final res = await _dataSource.searchBoards(query: _query, cursor: _nextCursor);
      if (!mounted) return;
      setState(() {
        _items.addAll(res.items);
        _nextCursor = res.nextCursor;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingMore = false;
        // 하단 로딩 실패는 스낵바 정도로 처리(화면 전체 에러로 바꾸지 않음)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('더 불러오기에 실패했어요: $e')),
        );
      });
    }
  }

  Future<void> _refresh() async {
    if (_query.trim().isEmpty) {
      // 최근 검색 화면일 때는 최근 목록 새로고침
      await _loadRecent();
    } else {
      await _searchFirst(_query);
    }
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final position = _scroll.position;
    if (position.maxScrollExtent - position.pixels < 320) {
      _searchMore();
    }
  }

  // ===== UI Actions =====
  void _onSubmit(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return;
    _saveRecent(value);
    _searchFirst(value);
  }

  void _onTapRecent(String term) {
    _controller.text = term;
    _onSubmit(term);
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: SaeipAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              SaeipSearchBar.detail(
                controller: _controller,
                onSubmit: _onSubmit,
                hintText: widget.hintText,
                onChanged: (v) {
                  // 자동완성/프리뷰 붙일 자리(원하면 여기서 _debouncer로 미리보기 가능)
                  _debouncer(() {
                    // setState(() {}); // 필요 시 UI 반영
                  });
                },
              ),

              const SizedBox(height: 16),

              if (_query.isEmpty) ...[
                // ===== 최근 검색 섹션 =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('최근 검색', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: _recent.isEmpty ? null : _clearRecent,
                      child: const Text('전체 삭제'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (_recentLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: SizedBox(
                        height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                else if (_recentError != null)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.error_outline),
                    title: const Text('최근 검색을 불러오지 못했어요.'),
                    subtitle: Text('$_recentError'),
                    trailing: TextButton(onPressed: _loadRecent, child: const Text('다시 시도')),
                  )
                else if (_recent.isEmpty)
                  const ListTile(
                    dense: true,
                    leading: Icon(Icons.history),
                    title: Text('최근 검색어가 없습니다'),
                  )
                else
                  ..._recent.map((term) {
                    return ListTile(
                      dense: true,
                      leading: Icon(Icons.history, color: primary),
                      title: Text(term),
                      onTap: () => _onTapRecent(term),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _removeRecent(term),
                        tooltip: '삭제',
                      ),
                    );
                  }),
              ] else ...[
                // ===== 검색 결과 섹션 =====
                Row(
                  children: [
                    const Text('검색 결과', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    if (_loading) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    if (!_loading && _items.isNotEmpty)
                      Text('(${_items.length}${_nextCursor != null ? '+' : ''})',
                          style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 8),

                if (_error != null)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.error_outline),
                    title: const Text('검색 중 문제가 발생했어요.'),
                    subtitle: Text('$_error'),
                    trailing: TextButton(onPressed: () => _searchFirst(_query), child: const Text('다시 시도')),
                  )
                else if (_loading && _items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  )
                else if (_items.isEmpty)
                  const ListTile(
                    dense: true,
                    leading: Icon(Icons.search_off),
                    title: Text('검색 결과가 없습니다'),
                  )
                else
                  ..._items.map((e) => _BoardTile(item: e, onTap: () {
                        // TODO: 게시글 상세로 이동하거나 원하는 액션 수행
                      })),

                if (_loadingMore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
                  ),
                if (!_loading && !_loadingMore && _nextCursor == null && _items.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text('마지막 결과입니다', style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ====== 결과 타일 UI ======
class _BoardTile extends StatelessWidget {
  const _BoardTile({required this.item, this.onTap});
  final _BoardItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ts = Theme.of(context).textTheme;
    return ListTile(
      dense: true,
      title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: ts.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: item.snippet == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(item.snippet!, maxLines: 2, overflow: TextOverflow.ellipsis, style: ts.bodySmall),
            ),
      trailing: item.createdAt == null ? null : Text(item.createdAt!, style: ts.labelSmall),
      onTap: onTap,
    );
  }
}

// ====== 데이터 모델/레포 (스텁) ================================================
// 실제 API 스펙에 맞게 교체하세요. (예: GET /api/v1/boards/search?query=...&cursor=...)
class _BoardItem {
  final String id;
  final String title;
  final String? snippet;
  final String? createdAt;

  const _BoardItem({required this.id, required this.title, this.snippet, this.createdAt});
}

class _SearchResult<T> {
  final List<T> items;
  final String? nextCursor;
  const _SearchResult({required this.items, required this.nextCursor});
}

/// 실제 서비스에선 dio 등으로 구현하세요.
/// 여기선 샘플 데이터를 비동기로 반환하는 스텁입니다.
class _BoardSearchDataSource {
  Future<_SearchResult<_BoardItem>> searchBoards({
    required String query,
    String? cursor,
  }) async {
    // TODO: 실제 API 호출로 교체
    await Future.delayed(const Duration(milliseconds: 450));

    // cursor는 단순히 페이지 번호처럼 취급 (스텁)
    final page = int.tryParse(cursor ?? '1') ?? 1;
    if (query.toLowerCase() == 'empty') {
      return const _SearchResult(items: [], nextCursor: null);
    }

    final gen = List.generate(10, (i) {
      final idx = (page - 1) * 10 + i + 1;
      return _BoardItem(
        id: 'post_$idx',
        title: '[$idx] $query 검색 결과 제목',
        snippet: '검색어 "$query" 를 포함하는 게시글의 요약 텍스트입니다. 상세는 API 데이터로 교체하세요.',
        createdAt: '2025-08-18',
      );
    });

    // 3페이지까지만 있는 것처럼 가정
    final next = page < 3 ? '${page + 1}' : null;
    return _SearchResult(items: gen, nextCursor: next);
  }
}
