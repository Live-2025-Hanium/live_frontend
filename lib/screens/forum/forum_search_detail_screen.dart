import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/providers/forum_search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'package:live_frontend/widgets/utils/recent_search_repo.dart';
import 'widgets/forum_recent_searches.dart';
import 'widgets/post_grid.dart';
import 'widgets/sort_controls.dart';

class ForumSearchDetailScreen extends ConsumerStatefulWidget {
  const ForumSearchDetailScreen({
    super.key,
    required this.externalController,
    required this.hintText,
  });

  final TextEditingController externalController;
  final String hintText;

  @override
  ConsumerState<ForumSearchDetailScreen> createState() =>
      _ForumSearchDetailScreenState();
}

class _ForumSearchDetailScreenState
    extends ConsumerState<ForumSearchDetailScreen> {
  static const int _maxRecent = 10;
  late final TextEditingController _controller = widget.externalController;
  final ScrollController _scroll = ScrollController();

  // recent state
  List<String> _recent = const [];
  bool _recentLoading = true;
  Object? _recentError;

  @override
  void initState() {
    super.initState();
    _loadRecent();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  // Recent search operations
  Future<void> _loadRecent() async {
    setState(() => _recentLoading = true);
    try {
      _recent = await RecentSearchRepo.fetchAll();
    } catch (e) {
      _recentError = e;
    } finally {
      setState(() => _recentLoading = false);
    }
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final p = _scroll.position;
    if (p.maxScrollExtent - p.pixels < 320) {
      ref.read(forumSearchProvider.notifier).loadMore();
    }
  }

  List<Widget> buildSearchResults(BuildContext context, ForumSearchState search) {
    return [
      // Sort controls
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverToBoxAdapter(
          child: SortControls(
            value: search.sort,
            onChanged: ref.read(forumSearchProvider.notifier).setSort,
          ),
        ),
      ),
      SliverPadding(
        padding: EdgeInsets.all(16.w),
        sliver: SliverToBoxAdapter(
          child: search.loading
              ? const Center(child: CircularProgressIndicator())
              : search.error != null
                  ? Center(child: Text('검색 중 오류가 발생했습니다'))
                  : search.items.isEmpty
                      ? Center(child: Text('검색 결과가 없습니다'))
                      : PostGridSliver(posts: search.items),
        ),
      ),
      if (search.loadingMore)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final search = ref.watch(forumSearchProvider);

    return Scaffold(
      appBar: SaeipAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scroll,
          slivers: [
            // Search bar
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              sliver: SliverToBoxAdapter(
                child: SaeipSearchBar.detail(
                  controller: _controller,
                  onSubmit: ref.read(forumSearchProvider.notifier).searchFirst,
                  hintText: widget.hintText,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),

            // Content
            if (search.query.isEmpty)
              ForumRecentSearches(
                items: _recent,
                loading: _recentLoading,
                error: _recentError,
                onTapTerm: (term) {
                  _controller.text = term;
                  ref.read(forumSearchProvider.notifier).searchFirst(term);
                },
                onDeleteTerm: (term) async {
                  await RecentSearchRepo.remove(term);
                  await _loadRecent();
                },
                onClearAll: () async {
                  await RecentSearchRepo.clear();
                  await _loadRecent();
                },
              )
            else
              ...buildSearchResults(context, search),
          ],
        ),
      ),
    );
  }
}
