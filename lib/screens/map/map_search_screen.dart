import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'widgets/map_search_temp_bar.dart';
import 'data/map_recent_search_temp_repo.dart'; // ← 임시 레포

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key, this.initialText});

  final String? initialText;

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText ?? '',
  );
  KakaoMapController? _mapController;

  // 최근 검색
  List<String> _recents = [];

  // 검색 상태
  bool _searched = false; // 검색 버튼/Submit 이후 true
  bool _loading = false;
  List<_Place> _results = [];
  List<Marker> _markers = [];

  // 바텀시트
  final _sheetCtrl = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _loadRecents();
  }

  Future<void> _loadRecents() async {
    final list = await MapRecentSearchTempRepo.fetchAll();
    if (!mounted) return;
    setState(() => _recents = list);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // TODO: 실제 REST API로 교체
  Future<void> _runSearch(String query) async {
    setState(() {
      _searched = true;
      _loading = true;
    });

    // ✅ 지도 전용 임시 레포에 저장
    await MapRecentSearchTempRepo.upsert(query, max: 10);
    _loadRecents();

    await Future.delayed(const Duration(milliseconds: 350)); // 모의 지연

    // 더미 결과: '없음' 이라는 단어 포함 시 빈 결과
    final hasAny = !query.contains('없음');

    List<_Place> data = [];
    if (hasAny) {
      data = List.generate(3, (i) {
        return _Place(
          id: 'p$i',
          name: i == 2 ? '고양이테라피아옹아옹아옹' : (i.isEven ? '더마음의원' : '강산 정신건강의학과'),
          category: '정신건강의학과',
          address: '서울 강동구 고덕로 266 4층 405호',
          status: i == 1 ? _BizStatus.closed : _BizStatus.open,
          statusNote: i == 1 ? '매주 화요일 휴무' : '18:00까지',
          thumbUrl: null,
          lat: 37.611846 + (i * 0.002),
          lng: 126.834059 + (i * 0.002),
        );
      });
    }

    // 마커 변환
    List<Marker> ms = [];
    if (_mapController != null) {
      final center = await _mapController!.getCenter();
      ms = data.isEmpty
          ? []
          : data
                .map(
                  (p) => Marker(
                    markerId: p.id,
                    latLng: LatLng(p.lat, p.lng),
                    infoWindowContent: p.name,
                  ),
                )
                .toList();

      if (ms.isNotEmpty) {
        await _mapController!.setCenter(ms.first.latLng);
      } else {
        await _mapController!.setCenter(center);
      }
    }

    setState(() {
      _results = data;
      _markers = ms;
      _loading = false;
    });

    if (ms.isNotEmpty && mounted && _sheetCtrl.size < 0.35) {
      // ignore: unawaited_futures
      _sheetCtrl.animateTo(
        0.35,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 상단 영역
            MapSearchTempBar.input(
              controller: _controller,
              hintText: '장소, 주소 검색',
              onSubmitted: (value) => _runSearch(value.trim()),
              onBack: () => Navigator.of(context).pop(),
              onTapSearch: () => _runSearch(_controller.text.trim()),
              showBottomDivider: true,
            ),

            Expanded(
              child: _searched
                  ? _buildAfterSearch(theme)
                  : _buildRecents(theme),
            ),
          ],
        ),
      ),
    );
  }

  // 최근 검색 화면
  Widget _buildRecents(ThemeData theme) {
    if (_recents.isEmpty) {
      // 빈 상태 시안
      return Padding(
        padding: EdgeInsets.only(top: 28.h, left: 20.w, right: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('최근 검색', highlight: true),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 52.h),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                  '최근 검색어가 없습니다.',
                  style: AppTextStyles.bodyRegular(
                    context,
                  ).copyWith(color: AppColors.blackBlack4),
                ),
              ),
            ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(top: 28.h, left: 20.w, right: 20.w),
      itemBuilder: (_, i) {
        if (i == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('최근 검색', highlight: true),
              _recentTile(_recents[0]),
            ],
          );
        }
        return _recentTile(_recents[i]);
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: _recents.length,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    );
  }

  Widget _sectionTitle(String text, {bool highlight = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        text,
        style: AppTextStyles.subtitleMedium(context).copyWith(
          color: highlight ? AppColors.greenNormal : Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _recentTile(String q) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(q, style: AppTextStyles.bodyRegular(context)),
      trailing: IconButton(
        icon: const Icon(Icons.close, color: AppColors.blackBlack3),
        onPressed: () async {
          // ✅ 지도 전용 임시 레포에서 삭제
          await MapRecentSearchTempRepo.remove(q);
          _loadRecents();
        },
      ),
      onTap: () {
        _controller.text = q;
        _runSearch(q);
      },
    );
  }

  // 검색 이후 화면 (지도 + 바텀시트)
  Widget _buildAfterSearch(ThemeData theme) {
    return Stack(
      children: [
        // 지도
        Positioned.fill(
          child: KakaoMap(
            markers: _markers,
            onMapCreated: (c) => _mapController = c,
          ),
        ),

        // 로딩
        if (_loading)
          const IgnorePointer(
            ignoring: true,
            child: Center(child: CircularProgressIndicator()),
          ),

        // 결과 없음 시안
        if (!_loading && _results.isEmpty)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 14.h),
              padding: EdgeInsets.symmetric(vertical: 28.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(blurRadius: 12, color: Colors.black26),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.place_outlined,
                    size: 40,
                    color: AppColors.greenNormal,
                  ),
                  Gap(12.h),
                  Text(
                    '검색 결과가 없습니다.',
                    style: AppTextStyles.titleMedium(context),
                  ),
                ],
              ),
            ),
          ),

        // 결과 바텀시트
        if (_results.isNotEmpty)
          DraggableScrollableSheet(
            controller: _sheetCtrl,
            initialChildSize: 0.20,
            minChildSize: 0.20,
            maxChildSize: 0.95,
            snap: true,
            snapSizes: const [0.20, 0.45, 0.95],
            builder: (context, scrollController) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    boxShadow: const [
                      BoxShadow(blurRadius: 14, color: Colors.black26),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 핸들
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 8.h),
                        child: Container(
                          width: 44.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                          itemBuilder: (_, i) => _resultCard(_results[i]),
                          separatorBuilder: (_, __) =>
                              const Divider(height: 24),
                          itemCount: _results.length,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _resultCard(_Place p) {
    final statusStyle = AppTextStyles.bodyMedium(context).copyWith(
      color: p.status == _BizStatus.open
          ? AppColors.greenNormal
          : AppColors.errorError3,
      fontWeight: FontWeight.w700,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 좌측 텍스트 묶음
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 이름 + 카테고리
              Row(
                children: [
                  Flexible(
                    child: Text(
                      p.name,
                      style: AppTextStyles.titleMedium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w800),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Gap(8),
                  Text(
                    p.category,
                    style: AppTextStyles.bodyMedium(
                      context,
                    ).copyWith(color: AppColors.blackBlack3),
                  ),
                ],
              ),
              Gap(6.h),
              Text(p.address, style: AppTextStyles.bodyRegular(context)),
              Gap(8.h),
              Row(
                children: [
                  Text(
                    p.status == _BizStatus.open ? '진료 중' : '영업 종료',
                    style: statusStyle,
                  ),
                  const Gap(6),
                  Text(p.statusNote, style: AppTextStyles.bodyRegular(context)),
                ],
              ),
              Gap(10.h),
              Row(
                children: [
                  _pillButton(Icons.call, '전화', onPressed: null), // 아직 비활성
                  const Gap(8),
                  _pillButton(Icons.route, '길 찾기', onPressed: null),
                ],
              ),
            ],
          ),
        ),

        // 썸네일
        const Gap(12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 96.w,
            height: 72.h,
            color: const Color(0xFFE5E7EB),
            child: p.thumbUrl == null
                ? const SizedBox.shrink()
                : Image.network(p.thumbUrl!, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  Widget _pillButton(IconData icon, String label, {VoidCallback? onPressed}) {
    final disabled = onPressed == null;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18,
        color: disabled ? AppColors.blackBlack3 : AppColors.blackBlack2,
      ),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: disabled
            ? AppColors.blackBlack3
            : AppColors.blackBlack2,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        side: BorderSide(
          color: disabled ? AppColors.blackBlack3 : AppColors.blackBlack2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );
  }
}

// ----- 더미 모델 -----
enum _BizStatus { open, closed }

class _Place {
  final String id;
  final String name;
  final String category;
  final String address;
  final _BizStatus status;
  final String statusNote;
  final String? thumbUrl;
  final double lat;
  final double lng;

  _Place({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.status,
    required this.statusNote,
    required this.thumbUrl,
    required this.lat,
    required this.lng,
  });
}
