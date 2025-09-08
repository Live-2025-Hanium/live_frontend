import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/models/forum_post_model.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    // --- 확장 props (선택/편집) ---
    this.onLongPress,
    this.editing = false,
    this.selected = false,
    this.selectionBuilder,
    this.selectionAlignment = Alignment.topRight,
    this.showSelectionOverlay = false,
  });

  final ForumPostModel post;
  final VoidCallback? onTap;

  // --- 확장 props ---
  final VoidCallback? onLongPress;
  final bool editing;
  final bool selected;
  final Alignment selectionAlignment;
  final bool showSelectionOverlay;
  final Widget Function(BuildContext context, bool selected)? selectionBuilder;

  String _thumbUrl() {
    final url = post.thumbnailImageUrl;
    if (url != null && url.isNotEmpty) return url;
    // 4:3(= aspectRatio 1.33)에 맞춰 Picsum 폴백 (글 id로 안정적인 시드)
    return 'https://picsum.photos/seed/scrap_${post.id}/600/450';
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${post.createdAt.year}.${post.createdAt.month.toString().padLeft(2, '0')}.${post.createdAt.day.toString().padLeft(2, '0')}';

    final selector =
        selectionBuilder?.call(context, selected) ?? _DefaultSelector(checked: selected);

    // 디바이스 픽셀 비율 기반 다운샘플(옵션)
    final gridColumn = 2; // 기본 2열
    final logicalTileWidth = MediaQuery.of(context).size.width / gridColumn - 16 * 2 / gridColumn;
    final cacheWidth = (logicalTileWidth * MediaQuery.of(context).devicePixelRatio).round();

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 썸네일 (+ 선택 인디케이터)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: 1.33, // 4:3
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: _thumbUrl(),
                    fit: BoxFit.cover,
                    memCacheWidth: cacheWidth, // iOS/Android 다운샘플
                    placeholder: (_, __) => const ColoredBox(color: Color(0xFFEDEDED)),
                    errorWidget: (_, __, ___) => const ColoredBox(color: Color(0xFFEDEDED)),
                  ),
                  if (editing && showSelectionOverlay)
                    Container(color: Colors.black.withOpacity(selected ? 0.12 : 0.0)),
                  if (editing)
                    Align(
                      alignment: selectionAlignment,
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: selector,
                      ),
                    ),
                ],
              ),
            ),
          ),

          Gap(8.h),

          // 제목
          Text(
            post.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyRegular(context),
          ),

          Gap(4.h),

          // 날짜
          Text(
            dateStr,
            style: AppTextStyles.smallMedium(context, color: AppColors.blackBlack4),
          ),
        ],
      ),
    );
  }
}

class _DefaultSelector extends StatelessWidget {
  const _DefaultSelector({required this.checked});
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.w,
      height: 24.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: checked ? AppColors.greenNormal : Colors.white,
        border: Border.all(
          color: AppColors.greenNormal,
          width: 2,
        ),
      ),
      child: checked ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
    );
  }
}
