import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForumRecentSearches extends StatelessWidget {
  const ForumRecentSearches({
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
          ...items.map((term) => _RecentSearchItem(
            term: term,
            onTap: () => onTapTerm(term),
            onDelete: () => onDeleteTerm(term),
          )),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '최근 검색어',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (items.isNotEmpty)
          TextButton(
            onPressed: onClearAll,
            child: const Text('전체 삭제'),
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
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
          ),
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
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
          ),
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
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        child: Row(
          children: [
            Icon(Icons.history, size: 20.sp, color: Colors.grey),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                term,
                style: TextStyle(fontSize: 14.sp),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, size: 20.sp),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}