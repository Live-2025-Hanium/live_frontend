import 'package:live_frontend/models/forum_post_comment_model.dart';

final dummyComments = <ForumPostCommentModel>[
  ForumPostCommentModel(
    id: 1,
    content: '저도 강아지를 키우고 나서 집에 있는 시간이 훨씬 덜 외로워졌어요.',
    authorNickname: 'Karina',
    createdAt: DateTime(2025, 8, 27, 18, 12),
    updatedAt: DateTime(2025, 8, 27, 18, 12),
    likeCount: 5,
    isLiked: false,
    isMyComment: false,
    replies: const [],
  ),
  ForumPostCommentModel(
    id: 2,
    content: '근데 같이 살던 강아지 죽으면 더 외로워짐...',
    authorNickname: '민들레',
    createdAt: DateTime(2025, 8, 27, 18, 14),
    updatedAt: DateTime(2025, 8, 27, 18, 14),
    likeCount: 13,
    isLiked: true,
    isMyComment: false,
    replies: const [],
  ),
  ForumPostCommentModel(
    id: 3,
    content: '공감이 많이 가는 글입니다.',
    authorNickname: '오늘도 아자아자',
    createdAt: DateTime(2025, 8, 27, 18, 20),
    updatedAt: DateTime(2025, 8, 27, 18, 20),
    likeCount: 13,
    isLiked: false,
    isMyComment: false,
    replies: const [],
  ),
];
