// lib/widgets/rating_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingBar extends StatelessWidget {
  /// 현재 채워진 별 개수 (0 ≤ rating ≤ maxRating)
  final int rating;

  /// 최대 별 개수 (기본 5)
  final int maxRating;

  /// 아이콘 크기 (ScreenUtil을 사용하기 전 값, 기본 16)
  final double iconSize;

  /// 별 색상 (기본 노란색)
  final Color color;

  const RatingBar({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.iconSize = 16,
    this.color = const Color(0xFFFFC800),
  }) : assert(rating >= 0 && rating <= maxRating);

  @override
  Widget build(BuildContext context) {
    final filled = rating;
    final empty = maxRating - rating;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 채워진 별
        for (var i = 0; i < filled; i++)
          Icon(Icons.star, size: iconSize.h, color: color),
        // 빈 별
        for (var i = 0; i < empty; i++)
          Icon(Icons.star_border, size: iconSize.h, color: color),
      ],
    );
  }
}
