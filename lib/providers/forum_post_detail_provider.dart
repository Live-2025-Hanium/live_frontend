import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/forum_post_detail_model.dart';
import 'package:live_frontend/screens/forum/data/dummy_post_detail.dart';

final postDetailProvider = FutureProvider.family<PostDetail, int>((
  ref,
  id,
) async {
  await Future.delayed(const Duration(milliseconds: 200)); // mock delay
  if (id == 1) return mockPostDetail;
  // TODO: 나중에 API 연결
  throw Exception('모킹 단계: id=1만 지원합니다.');
});
