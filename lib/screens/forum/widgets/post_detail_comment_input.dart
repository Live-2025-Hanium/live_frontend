import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:live_frontend/theme/app_colors.dart';

class PostDetailCommentInput extends StatelessWidget {
  const PostDetailCommentInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    this.replyTargetLabel,
    this.onClearReplyTarget,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final String? replyTargetLabel;
  final VoidCallback? onClearReplyTarget;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            final hasText = value.text.trim().isNotEmpty;

            return Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.blackBlack0, // 아주 연한 회색 배경
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) {
                        if (hasText) onSend();
                      },
                      decoration: InputDecoration(
                        isCollapsed: true,
                        hintText: '마음 속 이야기를 공유해봐요.',
                        hintStyle: TextStyle(
                          color: AppColors.blackBlack4,
                          fontSize: 16.sp,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // 종이비행기 아이콘
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: hasText ? onSend : null,
                    icon: SvgPicture.asset(
                      'assets/icons/send.svg',
                      width: 18.w,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
