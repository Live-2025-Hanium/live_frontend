import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_navigation_bar.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'package:live_frontend/screens/forum/widgets/banner_carousel.dart';
import 'package:live_frontend/screens/forum/widgets/category_chips.dart';
import 'package:live_frontend/screens/forum/widgets/post_card.dart';
import 'package:live_frontend/screens/forum/widgets/post_grid.dart';
import 'package:live_frontend/screens/forum/widgets/sort_controls.dart';

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

  // 더미 데이터
  List<ForumPost> get _posts => List.generate(
    12,
    (i) => ForumPost(
      id: 'p$i',
      title: '2020 경기도 「청년 마인드케어」, 참여자 모집',
      date: DateTime(2025, 1, 10),
      imageUrl: 'https://picsum.photos/seed/post$i/600/400',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SaeipAppBar(
        title: 'Forum',
        appBarStyle: AppBarStyle.common,
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/icons/bookmark.svg', height: 20),
            onPressed: () => debugPrint('bookmark tapped'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 검색창
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SaeipSearchBar(
                controller: _searchCtrl,
                hintText: '지원 사업, 생활 꿀팁',
                onSubmitted: (q) {
                  // TODO: 검색 실행
                  debugPrint('search: $q');
                },
              ),
            ),
          ),

          // 메인 배너
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BannerCarousel(
                itemCount: 10,
                index: _bannerIndex,
                onPageChanged: (i) => setState(() => _bannerIndex = i),
                itemBuilder: (_, i) => Image.network(
                  'https://picsum.photos/seed/banner$i/1200/675',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // 카테고리 칩
          SliverToBoxAdapter(
            child: CategoryChips(
              categories: const ['지원 사업', '마음 챙김', '생활 습관', '방문지 추천', '진로·직업'],
              selectedIndex: _selectedCategory,
              onSelected: (i) => setState(() => _selectedCategory = i),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // 정렬 옵션
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: SortControls(
                value: _sort,
                onChanged: (v) => setState(() => _sort = v),
              ),
            ),
          ),

          // 2열 카드 그리드
          PostGridSliver(
            posts: _posts,
            onTapPost: (post) {
              // TODO: 상세 화면 이동
              // context.pushNamed('postDetail', pathParameters: {'id': post.id});
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
      bottomNavigationBar: const SaeipNavigationBar(initialIndex: 3),
    );
  }
}
