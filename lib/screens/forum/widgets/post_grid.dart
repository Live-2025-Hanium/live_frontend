import 'package:flutter/material.dart';
import 'package:live_frontend/models/forum_post_model.dart';
import 'post_card.dart';

class PostGridSliver extends StatelessWidget {
  const PostGridSliver({
    super.key,
    required this.posts,
    this.onTapPost,
    // --- 확장 props ---
    this.onLongPressPost,
    this.editing = false,
    this.selectedIds = const {},
    this.selectionBuilder,
    this.selectionAlignment = Alignment.topRight,
    this.showSelectionOverlay = false,

    // 레이아웃 (기존 값 유지)
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 8,
    this.childAspectRatio = 0.78,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  });

  final List<ForumPostModel> posts;
  final void Function(ForumPostModel)? onTapPost;

  // --- 확장 props ---
  final void Function(ForumPostModel)? onLongPressPost;
  final bool editing;
  final Set<int> selectedIds;
  final Alignment selectionAlignment;
  final bool showSelectionOverlay;
  final Widget Function(BuildContext context, bool selected)? selectionBuilder;

  // layout
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final post = posts[index];
            final isSelected = selectedIds.contains(post.id);
            return PostCard(
              post: post,
              onTap: () => onTapPost?.call(post),
              onLongPress: onLongPressPost == null ? null : () => onLongPressPost!.call(post),
              editing: editing,
              selected: isSelected,
              selectionBuilder: selectionBuilder,
              selectionAlignment: selectionAlignment,
              showSelectionOverlay: showSelectionOverlay,
            );
          },
          childCount: posts.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
      ),
    );
  }
}
