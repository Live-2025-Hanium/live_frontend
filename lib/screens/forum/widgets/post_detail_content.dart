import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

/// 제목/메타/이미지/본문까지를 묶은 화면 전용 위젯
class PostDetailContent extends StatelessWidget {
  const PostDetailContent({
    super.key,
    required this.content,
    this.imageUrls = const <String>[],
    required this.id,
  });

  final String content;
  final List<String> imageUrls;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이미지
        if (imageUrls.isNotEmpty) ...[
          _SingleImage(url: imageUrls.first, id: id),
          Gap(16.h),
        ],

        // 본문
        _PostBody(content: content),
        Gap(24.h),
      ],
    );
  }
}

class _SingleImage extends StatelessWidget {
  const _SingleImage({required this.url, required this.id});
  final String url;
  final int id;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          url == "string" ? "https://picsum.photos/seed/post$id/600/400" : url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PostBody extends StatelessWidget {
  const _PostBody({required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    final paragraphs = content.split('\n\n').where((e) => e.trim().isNotEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs
          .map(
            (p) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Text(p, style: AppTextStyles.bodyRegular(context)),
            ),
          )
          .toList(),
    );
  }
}
