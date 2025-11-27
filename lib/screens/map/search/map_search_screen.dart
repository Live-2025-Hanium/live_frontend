import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'package:live_frontend/widgets/utils/recent_search_repo.dart';

import '../widgets/map_recent_searches.dart';
import 'package:go_router/go_router.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({
    super.key,
    required this.externalController,
    required this.hintText,
    this.onSearch,
  });

  final TextEditingController externalController;
  final String hintText;
  final ValueChanged<String>? onSearch;

  @override
  State<MapSearchScreen> createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  static const int _maxRecent = 10;

  late final TextEditingController _controller = widget.externalController;

  // recent state
  List<String> _recent = const [];
  bool _recentLoading = true;
  Object? _recentError;

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  Future<void> _loadRecent() async {
    setState(() => _recentLoading = true);
    try {
      _recent = (await RecentSearchRepo.map.fetchAll())
          .take(_maxRecent)
          .toList();
      _recentError = null;
    } catch (e) {
      _recentError = e;
    } finally {
      setState(() => _recentLoading = false);
    }
  }

  Future<void> _onSubmit(String raw) async {
    final term = raw.trim();
    if (term.isEmpty) return;

    await RecentSearchRepo.map.upsert(term);
    await _loadRecent();
    widget.onSearch?.call(term);
  }

  @override
  Widget build(BuildContext context) {
    final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    return Scaffold(
      appBar: AppBar(
        shape: const Border(
          bottom: BorderSide(color: AppColors.blackBlack3, width: 0.5),
        ),
        title: SaeipSearchBar.map(
          controller: widget.externalController,
          hintText: widget.hintText,
          onSubmit: (String query) {
            // 검색어 제출 시 동작 (여기서는 아무 동작도 하지 않음)
          },
        ),
        titleSpacing: 0,
        centerTitle: isIOS,
        leading: IconButton(
          icon: Icon(isIOS ? Icons.chevron_left : Icons.arrow_back, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Gap(8.h)),
            // 최근 검색어 목록 (지도 탭용)
            MapRecentSearches(
              items: _recent,
              loading: _recentLoading,
              error: _recentError,
              onTapTerm: (term) async {
                _controller.text = term;
                await _onSubmit(term);
              },
              onDeleteTerm: (term) async {
                await RecentSearchRepo.map.remove(term);
                await _loadRecent();
              },
              onClearAll: () async {
                await RecentSearchRepo.map.clear();
                await _loadRecent();
              },
            ),
          ],
        ),
      ),
    );
  }
}
