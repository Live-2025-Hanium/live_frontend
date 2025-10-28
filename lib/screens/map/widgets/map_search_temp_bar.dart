import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

/// 지도 검색 전용 상단 바 (시안 전용)
/// - 좌: 뒤로가기
/// - 가운데: [입력 모드] 힌트 텍스트가 보이는 얇은 TextField (아웃라인 없음)
///          [타이틀 모드] 굵은 제목 텍스트
/// - 우: 돋보기 아이콘 (탭 시 onTapSearch 호출)
///
/// SaeipSearchBar를 전혀 사용하지 않습니다.
class MapSearchTempBar extends StatelessWidget {
  const MapSearchTempBar.input({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.onBack,
    this.onTapSearch,
    this.hintText = '장소, 주소 검색',
    this.autoFocus = true,
    this.showBottomDivider = true,
  }) : mode = _MapSearchTempBarMode.input,
       title = null;

  const MapSearchTempBar.title({
    super.key,
    required this.title,
    this.onBack,
    this.onTapSearch,
    this.showBottomDivider = true,
  }) : mode = _MapSearchTempBarMode.title,
       controller = null,
       onSubmitted = null,
       hintText = null,
       autoFocus = false;

  final _MapSearchTempBarMode mode;

  // input 모드용
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final String? hintText;
  final bool autoFocus;

  // title 모드용
  final String? title;

  // 공통
  final VoidCallback? onBack;
  final VoidCallback? onTapSearch;
  final bool showBottomDivider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4, 6, 4, 6),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: mode == _MapSearchTempBarMode.input
                      ? _InputField(
                          controller: controller!,
                          hintText: hintText!,
                          autoFocus: autoFocus,
                          onSubmitted: onSubmitted,
                        )
                      : _TitleLabel(text: title ?? ''),
                ),
                IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  icon: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 20,
                    height: 20,
                  ),
                  onPressed: onTapSearch,
                ),
              ],
            ),
          ),
          if (showBottomDivider)
            const Divider(height: 0.5, color: AppColors.blackBlack3),
        ],
      ),
    );
  }
}

enum _MapSearchTempBarMode { input, title }

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    required this.autoFocus,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final bool autoFocus;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    // 시안처럼 얇고 심플한 텍스트 필드 (아웃라인/채움 없음)
    return SizedBox(
      height: 36,
      child: TextField(
        controller: controller,
        autofocus: autoFocus,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        style: AppTextStyles.bodyRegular(context),
        decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: AppTextStyles.bodyRegular(
            context,
          ).copyWith(color: AppColors.blackBlack4),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _TitleLabel extends StatelessWidget {
  const _TitleLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.titleMedium(
          context,
        ).copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}
