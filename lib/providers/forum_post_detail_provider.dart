import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/forum_post_detail_model.dart';
import 'package:live_frontend/models/forum_post_model.dart';
import 'package:live_frontend/screens/forum/data/dummy_forum_data.dart';

final postDetailProvider =
    FutureProvider.family<PostDetail, int>((ref, id) async {
  // TODO: API 연결 시 이 부분만 교체
  await Future.delayed(const Duration(milliseconds: 250));

  final ForumPost base = dummyForumPosts.firstWhere(
    (p) => p.id == id,
    orElse: () => throw Exception('게시글을 찾을 수 없습니다.'),
  );

  return PostDetail(
    id: base.id,
    title: base.title ?? '',
    content: '상세 본문은 준비 중이에요.',
    category: Category(id: base.category?.id ?? 0, name: base.category?.name ?? '정보'),
    relatedOrganization: base.relatedOrganization ?? '',
    images: [
      if ((base.thumbnailImageUrl ?? '').isNotEmpty)
        PostImage(id: 1, s3Url: base.thumbnailImageUrl!)
    ],
    authorNickname: base.authorNickname ?? '',
    viewCount: base.viewCount ?? 0,
    commentCount: 0,
    reactionCounts: {ReactionType.empathy: base.totalReactionCount ?? 0},
    userReactions: {},
    createdAt: base.createdAt,
    modifiedAt: base.createdAt,
  );
});
