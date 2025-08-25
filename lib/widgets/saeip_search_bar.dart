import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './utils/debouncer.dart';
import './utils/recent_search_repo.dart';
// import 'package:live_frontend/screens/forum/forum_search_detail_screen.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SaeipSearchBar extends StatefulWidget {
  // 기본: 상단 검색바 (탭/검색 시 상세 화면으로 이동만)
  const SaeipSearchBar({
    super.key,
    required this.controller,
    required this.onSubmit, // 메인에서는 호출하지 않음(상세에서만 사용)
    required this.hintText,
    this.logoSvgAsset,
    this.fillColor = Colors.white,
    this.borderColor = AppColors.greenNormal,
    this.textColor = Colors.black,
    this.hintColor = AppColors.blackBlack4,
    this.height = 40,
    this.radius = 8,
    this.maxRecent = 10,
    this.debounceMs = 250,
    this.onChanged,
  }) : _isDetail = false,
       _openDetailOnTap = true,
       _autoFocus = false;

  // 상세 화면 전용: 자동 포커스 + 상세 이동 금지 + 클리어 버튼 노출
  const SaeipSearchBar.detail({
    super.key,
    required this.controller,
    required this.onSubmit, // 상세에선 onSubmit이 실제 검색을 트리거
    required this.hintText,
    this.logoSvgAsset,
    this.fillColor = Colors.white,
    this.borderColor = AppColors.greenNormal,
    this.textColor = Colors.black,
    this.hintColor = AppColors.blackBlack4,
    this.height = 40,
    this.radius = 8,
    this.maxRecent = 10,
    this.debounceMs = 250,
    this.onChanged,
  }) : _isDetail = true,
       _openDetailOnTap = false,
       _autoFocus = true;

  // 공통 프로퍼티
  final TextEditingController controller;
  final ValueChanged<String> onSubmit;

  final String hintText;
  final String? logoSvgAsset; // 있으면 표시, 없으면 숨김
  final Color fillColor;
  final Color borderColor;
  final Color textColor;
  final Color hintColor;
  final double height;
  final double radius;
  final int maxRecent;
  final int debounceMs;
  final ValueChanged<String>? onChanged;

  // 프리셋 내부 제어
  final bool _isDetail;
  final bool _openDetailOnTap;
  final bool _autoFocus;

  @override
  State<SaeipSearchBar> createState() => _SaeipSearchBarState();
}

class _SaeipSearchBarState extends State<SaeipSearchBar> {
  late final Debouncer _debouncer = Debouncer(milliseconds: widget.debounceMs);
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget._autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _notifyChanged(String v) {
    final h = widget.onChanged;
    if (h == null) return;
    if (widget.debounceMs <= 0)
      h(v);
    else
      _debouncer(() => h(v));
  }

  void _openDetail() {
    // 검색 상세 화면으로 이동
    // Navigator.of(context).push(
    // MaterialPageRoute(
    //   builder: (_) => ForumSearchDetailScreen(
    //     externalController: widget.controller,
    //     hintText: widget.hintText,
    //   ),
    //   ),
    // );
  }

  void _handleSearchPressed() {
    final text = widget.controller.text.trim();

    if (widget._isDetail) {
      // 상세 : 네비게이션 금지
      if (text.isEmpty) {
        // 빈 값이면 아무 것도 하지 않거나, 포커스만 유지
        _focusNode.requestFocus();
        return;
      }
      RecentSearchRepo.upsert(text, max: widget.maxRecent);
      widget.onSubmit(text);
      return;
    }

    // 메인 : 상세로만 이동 (검색 실행은 상세에서)
    if (text.isEmpty) {
      _openDetail();
      return;
    }
    // 입력이 있어도 메인에선 검색 실행하지 않고 상세로 이동
    RecentSearchRepo.upsert(text, max: widget.maxRecent);
    _openDetail();
  }

  void _handleSubmitted(String raw) {
    final text = raw.trim();

    if (widget._isDetail) {
      // 상세 : submit이 실제 검색
      if (text.isEmpty) return;
      RecentSearchRepo.upsert(text, max: widget.maxRecent);
      widget.onSubmit(text);
      return;
    }

    // 메인 : submit 시에도 상세로만 이동
    if (text.isEmpty) {
      _openDetail();
      return;
    }
    RecentSearchRepo.upsert(text, max: widget.maxRecent);
    _openDetail();
  }

  @override
  Widget build(BuildContext context) {
    final side = BorderSide(color: widget.borderColor, width: 1.4);

    return SizedBox(
      height: widget.height.h,
      child: SearchBar(
        focusNode: _focusNode,
        controller: widget.controller,
        hintText: widget.hintText,
        elevation: const WidgetStatePropertyAll(0),
        backgroundColor: WidgetStatePropertyAll(widget.fillColor),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 12),
        ),
        textStyle: WidgetStatePropertyAll(
          TextStyle(color: widget.textColor, fontSize: 15),
        ),
        hintStyle: WidgetStatePropertyAll(
          TextStyle(color: widget.hintColor, fontSize: 15),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            side: side,
          ),
        ),
        // 왼쪽 로고 (옵션)
        leading: widget.logoSvgAsset == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SvgPicture.asset(
                  widget.logoSvgAsset!,
                  width: 20,
                  height: 20,
                ),
              ),
        // 오른쪽: 상세모드면 [X]+[검색], 기본모드면 [검색]만
        trailing: [
          GestureDetector(
            onTap: _handleSearchPressed,
            child: SizedBox(
              width: 20,
              height: 20,
              child: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 16,
                height: 16,
              ),
            ),
          ),
        ],
        onTap: () {
          if (widget._openDetailOnTap) _openDetail();
        },
        onChanged: _notifyChanged,
        onSubmitted: _handleSubmitted,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
