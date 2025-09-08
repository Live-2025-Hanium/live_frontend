import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/screens/forum/widgets/post_grid.dart';
import 'package:live_frontend/providers/forum_scrap_controller.dart';

class ForumScrapScreen extends ConsumerStatefulWidget {
  const ForumScrapScreen({super.key});

  @override
  ConsumerState<ForumScrapScreen> createState() => _ForumScrapScreenState();
}

class _ForumScrapScreenState extends ConsumerState<ForumScrapScreen> {
  final _scroll = ScrollController();
  DateTime? _lastLoadMore;
  static const double _scrollThreshold = 320.0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_lastLoadMore != null &&
        DateTime.now().difference(_lastLoadMore!) < const Duration(seconds: 1)) return;

    final s = ref.read(scrapControllerProvider);
    final p = _scroll.position;
    if (p.maxScrollExtent - p.pixels < _scrollThreshold) {
      if (!s.loading && !s.loadingMore && s.hasNext) {
        _lastLoadMore = DateTime.now();
        ref.read(scrapControllerProvider.notifier).loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(scrapControllerProvider);
    final ctrl = ref.read(scrapControllerProvider.notifier);

    return Scaffold(
      appBar: SaeipAppBar(
        title: '스크랩',
        actions: s.items.isEmpty
            ? null
            : [
                TextButton(
                  onPressed: ctrl.toggleEdit,
                  child: Text(
                    s.editing ? '완료' : '편집',
                    style: AppTextStyles.bodyMedium(context)
                        .copyWith(color: AppColors.blackBlack6),
                  ),
                ),
              ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scroll,
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 8.h)),

            if (s.loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (s.error != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    '목록을 불러오는 중 오류가 발생했습니다',
                    style: AppTextStyles.bodyRegular(context)
                        .copyWith(color: AppColors.blackBlack4),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else if (s.items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    '스크랩한 게시글이 없습니다.',
                    style: AppTextStyles.bodyRegular(context),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              PostGridSliver(
                posts: s.items,
                editing: s.editing,
                selectedIds: s.selected,
                showSelectionOverlay: false,
                onTapPost: (p) {
                  if (s.editing) {
                    ctrl.toggleSelect(p.id);
                  } else {
                    // TODO: 상세 이동
                  }
                },
                onLongPressPost: (p) {
                  if (!s.editing) ctrl.toggleEdit();
                  ctrl.toggleSelect(p.id);
                },
              ),

            if (s.loadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),

            SliverToBoxAdapter(
              child: SizedBox(height: s.editing && s.selected.isNotEmpty ? 88.h : 16.h),
            ),
          ],
        ),
      ),
      bottomSheet: s.editing && s.selected.isNotEmpty
          ? _BottomActionBar(
              count: s.selected.length,
              busy: s.acting,
              onUnScrap: () async {
                try {
                  await ctrl.unScrapSelected();
                } catch (_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('스크랩 해제에 실패했습니다. 잠시 후 다시 시도해 주세요.')),
                  );
                }
              },
            )
          : null,
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.onUnScrap, required this.count, required this.busy});
  final VoidCallback onUnScrap;
  final int count;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE6E6E6))),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: busy ? null : onUnScrap,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('스크랩 해제 ($count)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
