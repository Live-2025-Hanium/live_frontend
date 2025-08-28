import 'package:live_frontend/models/forum_post_detail_model.dart';

final mockPostDetail = PostDetail(
  id: 1,
  title: '“네가 있어 행복해”\n반려동물이 주는 정서적 효과',
  content:
      '반려동물과 함께 사는 가구는 2019년 591만 가구에서 2020년 638만 가구로 부쩍 늘었다. 아이들의 성화에 반려견을 입양하는 가정도 꽤 많다. 자녀가 반려견을 책임지고 관리하겠다는 굳은 약속을 하곤 한다. 우리 아이와 반려견, 유대감을 쌓고 가족처럼 잘 지낼 수 있을까?\n\n 지난 2017년 미국 플로리다대 심리학과 연구팀은 학술지 ≪사회발달≫에 반려견과 아동 대상 연구를 발표했다. 연구 결과, 아이들은 스트레스를 받을 때 반려견과 함께 있으면 스트레스 호르몬인 ‘코르티솔’을 덜 분비했다. 연구팀은 7~12세 아동 101명을 대상으로 실험을 진행했다. 먼저 아동을 많은 사람 앞에서 발표하거나, 암산 문제를 풀게 해 스트레스를 유발했다. 이때 A 집단은 반려견과 함께, B 집단은 부모와 함께, C 집단은 혼자 행동했다. 이후 아동의 타액을 채취해 코르티솔 수치를 측정했다. 그 결과, 부모와 함께한 B 집단의 스트레스 수준이 가장 낮았다. 하지만 반려견과 함께한 A 집단도 비슷한 효과가 있었다. 반려견이 함께 하거나 반려견을 쓰다듬은 아동은 혼자 있었던 C 집단 아동에 비해 코르티솔 수치가 낮았다. 연구팀은 “아동이 반려견과 상호작용하는 것은 스트레스 해소에 효과적이다”라며 “어린 시절 스트레스를 효과적으로 해소하는 방법을 배우면 성인이 돼 정신 건강에 도움이 될 수 있다”고 말했다.',
  category: Category(id: 10, name: '지원 사업'),
  relatedOrganization: '',
  images: [
    PostImage(id: 1, s3Url: 'https://picsum.photos/seed/detail1/800/600'),
  ],
  authorNickname: '서울 유기 동물 입양 센터',
  viewCount: 12321,
  commentCount: 3,
  reactionCounts: {ReactionType.empathy: 42},
  userReactions: {},
  createdAt: DateTime.parse('2025-08-27T15:11:53.443Z'),
  modifiedAt: DateTime.parse('2025-08-27T15:11:53.443Z'),
);
