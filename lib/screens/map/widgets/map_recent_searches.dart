import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/theme/app_colors.dart';

class MapRecentSearches extends StatelessWidget {
  const MapRecentSearches({
    super.key,
    required this.items,
    required this.onTapTerm,
    required this.onDeleteTerm,
    required this.onClearAll,
    this.loading = false,
    this.error,
  });

  final List<String> items;
  final ValueChanged<String> onTapTerm;
  final ValueChanged<String> onDeleteTerm;
  final VoidCallback onClearAll;
  final bool loading;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        // Header
        _buildHeader(context),
        SizedBox(height: 8.h),

        if (loading)
          _buildLoading()
        else if (error != null)
          _buildError(context)
        else if (items.isEmpty)
          _buildEmpty(context)
        else
          ...items.map(
            (term) => _RecentSearchItem(
              term: term,
              onTap: () => onTapTerm(term),
              onDelete: () => onDeleteTerm(term),
            ),
          ),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          child: Text(
            '최근 검색어',
            style: AppTextStyles.subtitleMedium(
              context,
              color: AppColors.greenNormal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Text(
          '최근 검색어를 불러오는데 실패했습니다',
          style: AppTextStyles.bodyRegular(
            context,
          ).copyWith(color: AppColors.blackBlack4),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Text(
          '최근 검색어가 없습니다',
          style: AppTextStyles.bodyRegular(
            context,
          ).copyWith(color: AppColors.blackBlack4),
        ),
      ),
    );
  }
}

class _RecentSearchItem extends StatelessWidget {
  const _RecentSearchItem({
    required this.term,
    required this.onTap,
    required this.onDelete,
  });

  final String term;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 4.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                term,
                style: AppTextStyles.bodyRegular(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 48.w,
              height: 48.w,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  size: 24.w,
                  color: AppColors.blackBlack3,
                ),
                onPressed: onDelete,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
