import 'package:live_frontend/models/forum_post_model.dart';

// 검색 결과 페이지 모델
class ForumSearchPage {
  final List<ForumPost> items;
  final String? nextCursor;

  const ForumSearchPage(this.items, this.nextCursor);
}

// Repository 인터페이스
abstract class ForumSearchRepository {
  Future<ForumSearchPage> searchBoards({
    required String query,
    String? cursor,
  });
}

class ForumSearchRepositoryImpl implements ForumSearchRepository {
  @override
  Future<ForumSearchPage> searchBoards({
    required String query,
    String? cursor,
  }) async {
    // TODO : API 연동
    await Future.delayed(const Duration(milliseconds: 450));

    final page = int.tryParse(cursor ?? '1') ?? 1;

    if (query.toLowerCase() == 'empty') {
      return const ForumSearchPage([], null);
    }

    final items = List.generate(10, (i) {
      final idx = (page - 1) * 10 + i + 1;
      return ForumPost(
        id: idx,
        title: '[$idx] $query 검색 결과 제목',
        category: Category(id: idx % 5, name: 'Category ${idx % 5}'),
        relatedOrganization: '관련기관 $idx',
        thumbnailImageUrl: 'https://picsum.photos/id/${(idx * 7) % 80}/800/600',
        authorNickname: '작성자$idx',
        viewCount: 100 + idx,
        totalReactionCount: 10 + idx,
        createdAt: DateTime.now().subtract(Duration(days: idx)),
      );
    });

    final next = page < 3 ? '${page + 1}' : null;
    return ForumSearchPage(items, next);
  }
}
