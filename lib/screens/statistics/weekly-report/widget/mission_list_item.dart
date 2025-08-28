import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class MissionListItem extends StatelessWidget {
  final MissionType type;
  final String missionTitle;
  final String completedTime;
  final VoidCallback? onTap;

  const MissionListItem({
    super.key,
    required this.type,
    required this.missionTitle,
    required this.completedTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          height: 48.h,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              // 타입에 따른 이미지
              _buildTypeImage(),
              Gap(16.w),
              // 미션 제목
              Expanded(
                child: Text(
                  missionTitle,
                  style: AppTextStyles.bodyRegular(context),
                ),
              ),
              // 완료 시간
              Text(
                completedTime,
                style: AppTextStyles.bodyRegular(
                  context,
                  color: AppColors.blackBlack4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeImage() {
    // type 값에 따라 다른 이미지 반환
    String imagePath = type == MissionType.my
        ? 'assets/images/MY.png'
        : 'assets/images/clover.png';

    return SizedBox(
      child: Image.asset(
        imagePath,
        width: 16.w,
        height: 16.w,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Log the error to make debugging easier (asset path, error message)
          debugPrint('Failed to load asset: $imagePath -> $error');
          if (stackTrace != null) debugPrint(stackTrace.toString());
          return SizedBox(
            width: 16.w,
            height: 16.w,
            child: Icon(Icons.task_alt, size: 20.w, color: Colors.green[600]),
          );
        },
      ),
    );
  }
}
