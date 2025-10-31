import 'package:live_frontend/models/forum_post_model.dart';

final dummyForumPosts = List.generate(
  6,
  (i) => ForumPostModel(
    id: i + 1, // int로 변경
    title: _dummyTitles[i % _dummyTitles.length],
    category: Category(id: 1, name: '지원 사업'),
    relatedOrganization: _dummyOrganizations[i % _dummyOrganizations.length],
    createdAt: DateTime.now().subtract(Duration(days: i)),
    thumbnailImageUrl: 'https://picsum.photos/seed/post${i + 1}/600/400',
    authorNickname: '작성자${i + 1}',
    viewCount: 100 + i,
    totalReactionCount: 10 + i,
  ),
);

const _dummyTitles = [
  '청년재단 청년 체인지업 프로젝트 참여자 모집',
  '실내에서 키우기 좋은 식물 10가지 추천',
  '서울식물원 청년 할인 프로그램 모집',
  '마음 챙김 명상은 어떻게 해야하나요? 6가지 효과를 알아보아요',
  '라이블리 Pick! 서울 근교 초록한 카페 추천',
  '고립은둔 청년을 위한 \'작은 시작\' 프로젝트',
];

const _dummyOrganizations = ['서울시청', '경기도청', '한국청년협회', '청년지원센터', '건강보험공단'];
