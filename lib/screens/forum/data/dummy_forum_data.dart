import 'package:live_frontend/models/forum_post_model.dart';

final dummyForumPosts = List.generate(
  10,
  (i) => ForumPostModel(
    id: i, // int로 변경
    title: _dummyTitles[i % _dummyTitles.length],
    category: Category(id: i % 5, name: 'Category ${i % 5}'),
    relatedOrganization: _dummyOrganizations[i % _dummyOrganizations.length],
    createdAt: DateTime.now().subtract(Duration(days: i)),
    thumbnailImageUrl: 'https://picsum.photos/seed/post$i/600/400',
    authorNickname: '작성자$i',
    viewCount: 100 + i,
    totalReactionCount: 10 + i,
  ),
);

const _dummyTitles = [
  '2024 경기도 「청년 마인드케어」, 참여자 모집',
  '서울시 청년 주거지원 사업 안내',
  '직장인 스트레스 관리 꿀팁',
  '취업 준비생을 위한 멘토링 프로그램',
  '청년 창업 지원 사업 설명회',
  '건강한 식습관 만들기 프로젝트',
  '우울증 극복 성공 사례',
  '청년 커뮤니티 활동가 모집',
];

const _dummyOrganizations = [
  '서울시청',
  '경기도청',
  '한국청년협회',
  '청년지원센터',
  '건강보험공단',
];