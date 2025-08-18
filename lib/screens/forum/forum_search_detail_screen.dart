// 수정 필요함

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'package:live_frontend/widgets/utils/debouncer.dart';
import 'package:live_frontend/widgets/utils/recent_search_repo.dart';

import 'package:live_frontend/screens/forum/widgets/sort_controls.dart';
import 'package:live_frontend/screens/forum/widgets/post_card.dart';
import 'package:live_frontend/screens/forum/widgets/post_grid.dart';

class ForumSearchDetailScreen extends StatefulWidget {
  const ForumSearchDetailScreen({
    super.key,
    required this.externalController,
    required this.hintText,
  });

  final TextEditingController externalController;
  final String hintText;

  @override
  State<ForumSearchDetailScreen> createState() =>
      _ForumSearchDetailScreenState();
}

class _ForumSearchDetailScreenState extends State<ForumSearchDetailScreen> {
  static const int _maxRecent = 10;

  // controllers
  late final TextEditingController _controller = widget.externalController;
  late final Debouncer _debouncer = Debouncer(milliseconds: 250);
  final ScrollController _scroll = ScrollController();

  // recent state
  List<String> _recent = const [];
  bool _recentLoading = true;
  Object? _recentError;

  // search state
  String _query = '';
  bool _loading = false;
  bool _loadingMore = false;
  Object? _error;
  String? _nextCursor;
  final List<_BoardItem> _items = [];

  // sort
  ForumSort _sort = ForumSort.latest;

  // data source (stub)
  final _BoardSearchDataSource _dataSource = _BoardSearchDataSource();

  // lifecycle
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

  // ===================== Recent Ops ======================
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

  // ===================== Search Ops ======================
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
      final res = await _dataSource.searchBoards(
        query: _query,
        cursor: _nextCursor,
      );
      if (!mounted) return;
      setState(() {
        _items.addAll(res.items);
        _nextCursor = res.nextCursor;
        _loadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('더 불러오기에 실패했어요: $e')));
    }
  }

  Future<void> _refresh() async {
    if (_query.trim().isEmpty) {
      await _loadRecent();
    } else {
      await _searchFirst(_query);
    }
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final p = _scroll.position;
    if (p.maxScrollExtent - p.pixels < 320) {
      _searchMore();
    }
  }

  // ===================== UI Actions ======================
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

  // ======================== UI ===========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scroll,
            slivers: [
              // 검색창
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                sliver: SliverToBoxAdapter(
                  child: SaeipSearchBar.detail(
                    controller: _controller,
                    onSubmit: _onSubmit,
                    hintText: widget.hintText,
                    onChanged: (v) => _debouncer(() {
                      // 자동완성 붙일 자리
                    }),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),

              ...(_query.isEmpty
                  ? _buildRecentSlivers(context)
                  : _buildResultSlivers(context)),

              SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------- Recent (Slivers) --------------------
  List<Widget> _buildRecentSlivers(BuildContext context) {
    return [
      // 헤더
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverToBoxAdapter(
          child: Row(
            children: [
              Text(
                '최근 검색',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton(
                onPressed: _recent.isEmpty ? null : _clearRecent,
                child: const Text('전체 삭제'),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 8.h)),

      if (_recentLoading)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        )
      else if (_recentError != null)
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Icon(Icons.error_outline, size: 18),
                const SizedBox(width: 8),
                const Expanded(child: Text('최근 검색을 불러오지 못했어요.')),
                TextButton(onPressed: _loadRecent, child: const Text('다시 시도')),
              ],
            ),
          ),
        )
      else if (_recent.isEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 48.h),
            child: Center(
              child: Text(
                '최근 검색어가 없습니다.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black45),
              ),
            ),
          ),
        )
      else
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverList.separated(
            itemCount: _recent.length,
            itemBuilder: (_, i) => _RecentRow(
              term: _recent[i],
              onTap: () => _onTapRecent(_recent[i]),
              onDelete: () => _removeRecent(_recent[i]),
            ),
            separatorBuilder: (_, __) => const SizedBox.shrink(),
          ),
        ),
    ];
  }

  // -------------------- Results (Slivers) --------------------
  List<Widget> _buildResultSlivers(BuildContext context) {
    // _items -> ForumPost 매핑 (이미지는 데모용)
    final posts = _items
        .map(
          (it) => ForumPost(
            id: it.id,
            title: it.title,
            date: DateTime.now(),
            imageUrl:
                'https://picsum.photos/id/${it.hashCode % 60 + 20}/800/600',
          ),
        )
        .toList();

    final slivers = <Widget>[
      // 우측 정렬 SortControls
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverToBoxAdapter(
          child: Row(
            children: [
              const Spacer(),
              SortControls(
                value: _sort,
                onChanged: (v) => setState(() => _sort = v),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 8.h)),
    ];

    if (_error != null) {
      slivers.add(
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                const Icon(Icons.error_outline, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('검색 중 문제가 발생했어요.\n$_error')),
                TextButton(
                  onPressed: () => _searchFirst(_query),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (_loading && posts.isEmpty) {
      slivers.add(
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        ),
      );
    } else if (posts.isEmpty) {
      slivers.add(const SliverToBoxAdapter(child: _EmptyResult()));
    } else {
      // ✅ 기존 PostGridSliver 재사용
      slivers.add(
        PostGridSliver(
          posts: posts,
          onTapPost: (p) {
            // TODO: 상세 이동
          },
          mainAxisSpacing: 24, // 세로 간격
          crossAxisSpacing: 8, // 가로 간격
          childAspectRatio: 0.78,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      );
    }

    // 하단 로딩/마지막
    if (_loadingMore) {
      slivers.add(
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ),
      );
    } else if (!_loading && _nextCursor == null && posts.isNotEmpty) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                '마지막 결과입니다',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      );
    }

    return slivers;
  }
}

// 최근 검색어
class _RecentRow extends StatelessWidget {
  const _RecentRow({required this.term, this.onTap, this.onDelete});

  final String term;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0x14000000), width: 1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                term,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              splashRadius: 18,
              icon: const Icon(Icons.close, size: 18),
              onPressed: onDelete,
              tooltip: '삭제',
            ),
          ],
        ),
      ),
    );
  }
}

// 검색 결과 없음
class _EmptyResult extends StatelessWidget {
  const _EmptyResult();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 56.h),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0x1F1A9C5F),
              border: Border.all(color: const Color(0x331A9C5F), width: 2),
            ),
            child: const Center(
              child: Icon(Icons.search_off, size: 44, color: Color(0xFF1A9C5F)),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            '검색 결과가 없습니다.',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

// =================== Stub models / data source ===========
class _BoardItem {
  final String id;
  final String title;
  final String? snippet; // 미사용 (리스트형일 때 활용)
  final String? createdAt;

  const _BoardItem({
    required this.id,
    required this.title,
    this.snippet,
    this.createdAt,
  });
}

class _SearchResult<T> {
  final List<T> items;
  final String? nextCursor;
  const _SearchResult({required this.items, required this.nextCursor});
}

class _BoardSearchDataSource {
  Future<_SearchResult<_BoardItem>> searchBoards({
    required String query,
    String? cursor,
  }) async {
    // TODO: 실제 API 호출(dio 등)로 교체
    await Future.delayed(const Duration(milliseconds: 450));

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

    final next = page < 3 ? '${page + 1}' : null;
    return _SearchResult(items: gen, nextCursor: next);
  }
}
