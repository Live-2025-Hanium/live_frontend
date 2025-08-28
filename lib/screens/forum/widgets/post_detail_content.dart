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
          _ImagesCarousel(urls: imageUrls),
          Gap(16.h),
        ],

        // 본문
        _PostBody(content: content),
        Gap(24.h),
      ],
    );
  }
}

class _ImagesCarousel extends StatefulWidget {
  const _ImagesCarousel({required this.urls});
  final List<String> urls;

  @override
  State<_ImagesCarousel> createState() => _ImagesCarouselState();
}

class _ImagesCarouselState extends State<_ImagesCarousel> {
  final PageController _page = PageController();
  int _index = 0;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.urls.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: PageView.builder(
            controller: _page,
            itemCount: widget.urls.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(widget.urls[i], fit: BoxFit.cover),
            ),
          ),
        ),
        Gap(8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.urls.length,
            (i) => Container(
              width: 6.w,
              height: 6.w,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _index ? AppColors.blackBlack3 : AppColors.blackBlack1,
              ),
            ),
          ),
        ),
      ],
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
          .map((p) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Text(p, style: AppTextStyles.bodyRegular(context)),
              ))
          .toList(),
    );
  }
}
