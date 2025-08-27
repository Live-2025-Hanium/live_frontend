class Category {
  final int id;
  final String name;

  const Category({
    required this.id,
    required this.name,
  });
}

class ForumPost {
  final int id;
  final String title;
  final Category category;
  final String relatedOrganization;
  final DateTime createdAt;
  final String? thumbnailImageUrl;
  final String? authorNickname;
  final int? viewCount;
  final int? totalReactionCount;

  const ForumPost({
    required this.id,
    required this.title,
    required this.category,
    required this.relatedOrganization,
    required this.createdAt,
    this.thumbnailImageUrl,
    this.authorNickname,
    this.viewCount,
    this.totalReactionCount,
  });

  // 나중에 필요하다면 fromJson, toJson 메서드도 추가
}
