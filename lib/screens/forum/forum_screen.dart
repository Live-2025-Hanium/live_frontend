import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'package:live_frontend/screens/forum/widgets/banner_carousel.dart';
import 'package:live_frontend/screens/forum/widgets/category_chips.dart';
import 'package:live_frontend/screens/forum/widgets/post_grid.dart';
import 'package:live_frontend/screens/forum/widgets/sort_controls.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/forum_post_model.dart';
import 'data/dummy_forum_data.dart';
import 'forum_scrap_screen.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final _searchCtrl = TextEditingController();

  int _bannerIndex = 0;
  int _selectedCategory = 0;
  ForumSort _sort = ForumSort.latest;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ForumPostModel> get _posts {
    return _getFilteredAndSortedPosts(
      categoryId: _selectedCategory,
      sort: _sort,
    );
  }

  List<ForumPostModel> _getFilteredAndSortedPosts({
    required int categoryId,
    required ForumSort sort,
  }) {
    // 1. 카테고리 필터링
    List<ForumPostModel> filtered;

    if (categoryId == 0) {
      filtered = dummyForumPosts;
    } else if (categoryId == 1) {
      filtered = dummyForumPosts
          .where((post) => post.category.id == 0 || post.category.id == 1)
          .toList();
    } else {
      filtered = [];
    }

    // 2. 정렬
    filtered.sort((a, b) {
      switch (sort) {
        case ForumSort.latest:
          return b.createdAt.compareTo(a.createdAt);
        case ForumSort.views:
          return (b.viewCount ?? 0).compareTo(a.viewCount ?? 0);
        case ForumSort.scraps:
          return (b.totalReactionCount ?? 0).compareTo(
            a.totalReactionCount ?? 0,
          );
      }
    });

    return filtered;
  }

  // CategoryChips 위젯의 카테고리 목록
  static const _categories = [
    '전체',
    '지원 사업',
    '마음 챙김',
    '생활 습관',
    '사회 연결',
    '진로·직업',
  ];

  void _openScrap() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ForumScrapScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      clipBehavior: Clip.none,
      slivers: [
        // 검색창
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SaeipSearchBar(
              controller: _searchCtrl,
              hintText: '지원 사업, 생활 꿀팁',
              onSubmit: (q) {
                // TODO: 검색 실행
                //  debugPrint('search: $q');
              },
            ),
          ),
        ),

        SliverGap(16),

        // 메인 배너
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: BannerCarousel(
              itemCount: 10,
              index: _bannerIndex,
              onPageChanged: (i) => setState(() => _bannerIndex = i),
              onTap: (index) =>
                  context.pushNamed('forum_post', pathParameters: {'id': '1'}),
              itemBuilder: (_, i) => Image.network(
                // TODO : 추후 API 연동 예정
                'https://picsum.photos/id/${30 + i}/1200/675',
                fit: BoxFit.cover,
              ),
              overlayBuilder: (_, i) => BannerOverlay(
                // TODO : 추후 API 연동 예정
                title: '“네가 있어 행복해” 반려동물이 주는 정서적 효과',
                subtitle: '서울 유기 동물 입양 센터',
              ),
            ),
          ),
        ),

        SliverGap(24),

        // 카테고리 칩
        SliverToBoxAdapter(
          child: CategoryChips(
            categories: _categories,
            selectedIndex: _selectedCategory,
            onSelected: (i) => setState(() => _selectedCategory = i),
          ),
        ),

        // 정렬 옵션
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerRight,
              child: SortControls(
                value: _sort,
                onChanged: (v) => setState(() => _sort = v),
              ),
            ),
          ),
        ),

        // 2열 카드 그리드
        PostGridSliver(
          posts: _posts,
          onTapPost: (post) {
            context.pushNamed(
              'forum_post',
              pathParameters: {'id': '${post.id}'},
            );
          },
        ),
      ],
    );
  }
}
