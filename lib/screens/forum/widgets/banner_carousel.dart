import 'package:flutter/material.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.index,
    this.onPageChanged,
    this.showAdBadge = true,
    this.aspectRatio = 16 / 9,
    this.borderRadius = 12,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final int? index;
  final ValueChanged<int>? onPageChanged;
  final bool showAdBadge;
  final double aspectRatio;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: onPageChanged,
            itemCount: itemCount,
            itemBuilder: (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: itemBuilder(context, i),
            ),
          ),
          if (showAdBadge)
            _badge(left: 8, top: 8, text: 'AD'),
          if (index != null)
            _badge(
              right: 8,
              top: 8,
              text: '${(index! + 1)}/$itemCount',
            ),
        ],
      ),
    );
  }

  Positioned _badge({
    double? left,
    double? right,
    required double top,
    required String text,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
