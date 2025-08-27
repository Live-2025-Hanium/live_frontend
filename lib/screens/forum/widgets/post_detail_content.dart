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
    required this.title,
    required this.date,
    required this.views,
    required this.comments,
    this.scraps = 0,
    required this.content,
    this.imageUrls = const <String>[],
  });

  final String title;
  final DateTime date;
  final int views;
  final int comments;
  final int scraps;
  final String content;
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Text(title, style: AppTextStyles.titleSemibold(context)),
        Gap(6.h),

        // 메타(날짜/조회/댓글/스크랩)
        _PostMetaRow(
          date: date,
          views: views,
          comments: comments,
          scraps: scraps,
        ),

        const Divider(height: 24),

        // 이미지 캐러셀
        if (imageUrls.isNotEmpty) ...[
          _ImagesCarousel(urls: imageUrls),
          Gap(16.h),
        ],

        // 본문
        _PostBody(content: content),

        const Divider(height: 24),
      ],
    );
  }
}

class _PostMetaRow extends StatelessWidget {
  const _PostMetaRow({
    required this.date,
    required this.views,
    required this.scraps,
    required this.comments,
  });

  final DateTime date;
  final int views;
  final int scraps;
  final int comments;

  @override
  Widget build(BuildContext context) {
    final d = '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}.';
    final sub = AppTextStyles.smallMedium(context);

    Widget iconText(IconData i, String t) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(i, size: 16.sp, color: AppColors.blackBlack3),
            Gap(4.w),
            Text(t, style: sub),
          ],
        );

    return Row(
      children: [
        Text(d, style: sub),
        const Spacer(),
        iconText(Icons.visibility, views.toString()),
        Gap(12.w),
        iconText(Icons.comment, comments.toString()),
        Gap(12.w),
        iconText(Icons.bookmarks_outlined, scraps.toString()),
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
