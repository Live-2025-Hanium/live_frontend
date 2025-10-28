import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:gap/gap.dart';

typedef BannerOverlayBuilder = Widget Function(BuildContext context, int index);

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,

    // 외부 제어
    this.index,
    this.initialIndex = 0,
    this.onPageChanged,
    this.onTap,

    // 레이아웃
    this.aspectRatio = 1.65,
    this.borderRadius = 8,
    this.pageSpacing = 8,
    this.padEnds = false,

    // 자동재생
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.autoPlayDuration = const Duration(milliseconds: 350),
    this.autoPlayCurve = Curves.easeOut,

    // 배지/오버레이
    this.showAdBadge = true,
    this.adBadgeText = 'AD',
    this.showIndexBadge = true,
    this.enableScrim = true,
    this.scrimColors = const [Color(0xCC000000), Color(0x00000000)],
    this.overlayBuilder,

    this.peekRight = 16,
  });

  // 본문
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  // 외부 인덱스 제어
  final int? index;
  final int initialIndex;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<int>? onTap;

  // 레이아웃
  final double aspectRatio;
  final double borderRadius;
  final double pageSpacing;
  final bool padEnds;

  // 자동재생
  final bool autoPlay;
  final Duration autoPlayInterval;
  final Duration autoPlayDuration;
  final Curve autoPlayCurve;

  // 배지/오버레이
  final bool showAdBadge;
  final String adBadgeText;
  final bool showIndexBadge;
  final bool enableScrim;
  final List<Color> scrimColors;
  final BannerOverlayBuilder? overlayBuilder;

  final double peekRight;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final CarouselSliderController _carouselCtrl = CarouselSliderController();
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _current = _clampIndex(widget.index ?? widget.initialIndex);
  }

  @override
  void didUpdateWidget(covariant BannerCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 외부 index 변경 시 애니메이션 이동
    if (widget.index != null &&
        widget.index != oldWidget.index &&
        widget.index != _current &&
        widget.itemCount > 0) {
      final target = _clampIndex(widget.index!);
      _carouselCtrl.animateToPage(
        target,
        duration: widget.autoPlayDuration,
        curve: widget.autoPlayCurve,
      );
    }

    // itemCount 변경 시 현재 인덱스 보정
    final clamped = _clampIndex(_current);
    if (clamped != _current) {
      _current = clamped;
      _carouselCtrl.jumpToPage(_current);
    }
  }

  int _clampIndex(int i) {
    if (widget.itemCount <= 0) return 0;
    if (i < 0) return 0;
    if (i >= widget.itemCount) return widget.itemCount - 1;
    return i;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount <= 0) {
      return AspectRatio(aspectRatio: widget.aspectRatio, child: _empty());
    }

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        clipBehavior: Clip.none, // 내부 오버플로우 허용
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth;
              final peek = widget.peekRight;
              final gap = widget.pageSpacing;
              // 실제 슬라이더 폭 = 카드폭 + peek
              final sliderWidth = cardWidth + peek;
              final viewportFraction = (cardWidth + gap) / sliderWidth;

              return OverflowBox(
                alignment: Alignment.centerLeft,
                minWidth: sliderWidth,
                maxWidth: sliderWidth,
                child: SizedBox(
                  width: sliderWidth,
                  child: CarouselSlider.builder(
                    carouselController: _carouselCtrl,
                    itemCount: widget.itemCount,
                    itemBuilder: (context, i, realIdx) {
                      final rightGap = widget.pageSpacing;

                      return Padding(
                        padding: EdgeInsets.only(right: rightGap),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius,
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Material(
                                child: InkWell(
                                  onTap: widget.onTap == null
                                      ? null
                                      : () => widget.onTap!(i),
                                  child: widget.itemBuilder(context, i),
                                ),
                              ),

                              if (widget.enableScrim)
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: IgnorePointer(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: widget.scrimColors,
                                          stops: const [0.0, 0.55],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (widget.overlayBuilder != null)
                                Positioned.fill(
                                  child: widget.overlayBuilder!(context, i),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      initialPage: _clampIndex(
                        widget.index ?? widget.initialIndex,
                      ),
                      viewportFraction: viewportFraction,
                      padEnds: widget.padEnds,
                      autoPlay: widget.autoPlay && widget.itemCount > 1,
                      autoPlayInterval: widget.autoPlayInterval,
                      autoPlayAnimationDuration: widget.autoPlayDuration,
                      autoPlayCurve: widget.autoPlayCurve,
                      enlargeCenterPage: false,
                      onPageChanged: (i, reason) {
                        if (_current != i) {
                          setState(() => _current = i);
                          widget.onPageChanged?.call(i);
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          ),

          if (widget.showAdBadge)
            _pillBadge(left: 8, top: 8, text: widget.adBadgeText),

          if (widget.showIndexBadge)
            _pillBadge(
              right: 8,
              top: 8,
              text: '${_current + 1}/${widget.itemCount}',
            ),
        ],
      ),
    );
  }

  Positioned _pillBadge({
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
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: AppTextStyles.smallMedium(context)),
      ),
    );
  }

  Widget _empty() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.black38),
      ),
    );
  }
}

class BannerOverlay extends StatelessWidget {
  const BannerOverlay({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: AppTextStyles.bodySemibold(context, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            Gap(6),

            Text(
              title,
              style: AppTextStyles.titleSemibold(context, color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
