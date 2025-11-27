import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_search_bar.dart';
import 'package:live_frontend/widgets/utils/recent_search_repo.dart';

import '../widgets/map_recent_searches.dart';

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
      _recent = (await RecentSearchRepo.fetchAll()).take(_maxRecent).toList();
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

    await RecentSearchRepo.upsert(term);
    await _loadRecent();
    widget.onSearch?.call(term);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 검색바
            SliverPadding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              sliver: SliverToBoxAdapter(
                child: SaeipSearchBar.detail(
                  controller: _controller,
                  hintText: widget.hintText,
                  onSubmit: _onSubmit,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),

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
                await RecentSearchRepo.remove(term);
                await _loadRecent();
              },
              onClearAll: () async {
                await RecentSearchRepo.clear();
                await _loadRecent();
              },
            ),
          ],
        ),
      ),
    );
  }
}
