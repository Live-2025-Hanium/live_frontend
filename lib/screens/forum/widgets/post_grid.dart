import 'package:flutter/material.dart';
import 'post_card.dart';

class PostGridSliver extends StatelessWidget {
  const PostGridSliver({
    super.key,
    required this.posts,
    this.onTapPost,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 12,
    this.crossAxisSpacing = 12,
    this.childAspectRatio = 0.78,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  });

  final List<ForumPost> posts;
  final void Function(ForumPost)? onTapPost;

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
          (context, index) => PostCard(
            post: posts[index],
            onTap: () => onTapPost?.call(posts[index]),
          ),
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
