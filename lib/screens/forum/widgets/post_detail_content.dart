import 'package:flutter/material.dart';
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
  });

  final String content;
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이미지
        if (imageUrls.isNotEmpty) ...[
          _SingleImage(url: imageUrls.first),
          Gap(16),
        ],

        // 본문
        _PostBody(content: content),
        Gap(24),
      ],
    );
  }
}

class _SingleImage extends StatelessWidget {
  const _SingleImage({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(url, fit: BoxFit.cover),
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
              padding: EdgeInsets.only(bottom: 12),
              child: Text(p, style: AppTextStyles.bodyRegular(context)),
            ),
          )
          .toList(),
    );
  }
}
