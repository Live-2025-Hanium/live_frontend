import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:live_frontend/screens/map/widgets/map_appbar.dart';
import 'package:live_frontend/widgets/utils/recent_search_repo.dart';
import '../widgets/map_recent_searches.dart';

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({
    super.key,
    required this.externalController,
    required this.hintText,
  });

  final TextEditingController externalController;
  final String hintText;

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

  @override
  Widget build(BuildContext context) {
    Future<void> onSubmit(String raw) async {
      final term = raw.trim();
      if (term.isEmpty) return;

      await RecentSearchRepo.map.upsert(term);
      await _loadRecent();
      context.pushNamed(
        'map_search_result',
        extra: {'externalController': _controller, 'hintText': widget.hintText},
      );
    }

    return Scaffold(
      appBar: MapAppBar(
        externalController: _controller,
        hintText: widget.hintText,
        onSubmit: onSubmit,
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
                await onSubmit(term);
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
