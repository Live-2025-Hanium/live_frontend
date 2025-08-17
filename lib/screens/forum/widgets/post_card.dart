import 'package:flutter/material.dart';

class ForumPost {
  final String id;
  final String title;
  final DateTime date;
  final String imageUrl;

  const ForumPost({
    required this.id,
    required this.title,
    required this.date,
    required this.imageUrl,
  });
}

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  final ForumPost post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${post.date.year}.${post.date.month.toString().padLeft(2, '0')}.${post.date.day.toString().padLeft(2, '0')}';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: Image.network(post.imageUrl, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                post.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
              child: Text(
                dateStr,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
