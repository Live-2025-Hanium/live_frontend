import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_frontend/providers/forum_search_provider.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'package:live_frontend/widgets/utils/recent_search_repo.dart';

import 'widgets/forum_recent_searches.dart';
import 'widgets/post_grid.dart';
import 'widgets/sort_controls.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:gap/gap.dart';

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
  static const double _scrollThreshold = 320.0;

  DateTime? _lastLoadMore;
  late final TextEditingController _controller = widget.externalController;
  final ScrollController _scroll = ScrollController();

  // recent state
  List<String> _recent = const [];
  bool _recentLoading = true;
  Object? _recentError;

  @override
  void initState() {
    super.initState();

    // 빌드 이후 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(forumSearchProvider.notifier).reset();
    });

    _loadRecent();
    _controller.addListener(_onTextChanged);
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();

    _controller.removeListener(_onTextChanged);
    _controller.clear();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  Future<void> _loadRecent() async {
    setState(() => _recentLoading = true);
    try {
      _recent = (await RecentSearchRepo.fetchAll()).take(_maxRecent).toList();
      _recentError = null;
    } catch (e) {
      _recentError = e;
    } finally {
      setState(() => _recentLoading = false);
    }
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;

    if (_lastLoadMore != null &&
        DateTime.now().difference(_lastLoadMore!) < const Duration(seconds: 1))
      return;

    final p = _scroll.position;
    if (p.maxScrollExtent - p.pixels < _scrollThreshold) {
      final state = ref.read(forumSearchProvider);
      if (state.loading || state.loadingMore) return;

      _lastLoadMore = DateTime.now();
      ref.read(forumSearchProvider.notifier).loadMore();
    }
  }

  List<Widget> buildSearchResults(
    BuildContext context,
    ForumSearchState search,
  ) {
    return [
      // 정렬 컨트롤
      SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.centerRight,
            child: SortControls(
              value: search.sort,
              onChanged: (v) =>
                  ref.read(forumSearchProvider.notifier).setSort(v),
            ),
          ),
        ),
      ),

      // 결과 영역
      if (search.loading)
        SliverFillRemaining(hasScrollBody: false, child: const _Loading())
      else if (search.error != null)
        SliverFillRemaining(
          hasScrollBody: false,
          child: _MessageCenter(text: '검색 중 오류가 발생했습니다'),
        )
      else if (search.items.isEmpty)
        // ✅ 레퍼런스처럼 중앙에 빈 상태
        SliverFillRemaining(hasScrollBody: false, child: const _EmptyResult())
      else
        // 실제 결과
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverToBoxAdapter(
            child: PostGridSliver(posts: search.items),
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
            // 검색바
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              sliver: SliverToBoxAdapter(
                child: SaeipSearchBar.detail(
                  controller: _controller,
                  hintText: widget.hintText,
                  onSubmit: (raw) async {
                    final term = raw.trim();
                    if (term.isEmpty) return;

                    // 최근 검색어 저장
                    await RecentSearchRepo.upsert(term);
                    await _loadRecent();

                    // 검색 실행
                    ref.read(forumSearchProvider.notifier).searchFirst(term);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),

            // 콘텐츠
            if (_controller.text.isEmpty)
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

/// --- 빈 상태 / 로딩 상태 UI들 ---

class _EmptyResult extends StatelessWidget {
  const _EmptyResult();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset('assets/icons/search_no_result.svg'),
        ),
        Gap(20.h),
        Text(
          '검색 결과가 없습니다.',
          style: AppTextStyles.bodyRegular(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _MessageCenter extends StatelessWidget {
  const _MessageCenter({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Text(
          text,
          style: AppTextStyles.bodyRegular(
            context,
          ).copyWith(color: AppColors.blackBlack4),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
