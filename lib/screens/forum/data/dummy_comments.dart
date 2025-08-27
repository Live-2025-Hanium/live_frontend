import 'package:live_frontend/models/forum_post_comment_model.dart';

final dummyComments = <ForumPostComment>[
  ForumPostComment(
    id: 1,
    content: '저도 강아지를 키우고 나서 집에 있는 시간이 훨씬 늘었어요.',
    authorNickname: 'Karina',
    createdAt: DateTime(2025, 8, 27, 18, 12),
    updatedAt: DateTime(2025, 8, 27, 18, 12),
    likeCount: 2,
    isLiked: false,
    isMyComment: false,
    replies: ['공감합니다!', '맞아요 저도요.'],
  ),
  ForumPostComment(
    id: 2,
    content: '근데 같이 살던 강아지 떠났던 게… ㅠ',
    authorNickname: '민들레',
    createdAt: DateTime(2025, 8, 27, 18, 14),
    updatedAt: DateTime(2025, 8, 27, 18, 14),
    likeCount: 5,
    isLiked: true,
    isMyComment: false,
    replies: ['힘내세요 🙏'],
  ),
  ForumPostComment(
    id: 3,
    content: '공감이 많이 가는 글입니다.',
    authorNickname: '오늘도 이지아',
    createdAt: DateTime(2025, 8, 27, 18, 20),
    updatedAt: DateTime(2025, 8, 27, 18, 20),
    likeCount: 13,
    isLiked: false,
    isMyComment: true,
    replies: const [],
  ),
];
