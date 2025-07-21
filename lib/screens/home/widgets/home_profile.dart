import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

class HomeProfile extends StatelessWidget {
  final String profileImageSrc;
  final int todayCloverCount;
  final int todayFinishedMissionCount;

  const HomeProfile({
    super.key,
    required this.profileImageSrc,
    required this.todayCloverCount,
    required this.todayFinishedMissionCount,
  });

  @override
  Widget build(BuildContext context) {
    String dateString = Jiffy.now().format(pattern: 'yyyy년 M월 d일');
    return Container(
      height: 116.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
            child: SizedBox(
              width: 84.h,
              height: 84.h,
              child: CachedNetworkImage(
                imageUrl: profileImageSrc,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Colors.grey.shade200,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                errorWidget: (context, url, error) {
                  debugPrint('Avatar load error: $error');
                  return Container(
                    color: Colors.grey.shade200,
                    child: Icon(
                      Icons.person,
                      size: 42.h,
                      color: Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),
          ),
          Gap(20.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                dateString,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.blackBlack5,
                ),
              ),
              Gap(12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '오늘 모은 클로버',
                    style: AppTextStyles.subtitleMedium(
                      context,
                      color: Colors.black,
                    ).copyWith(fontWeight: FontWeight.w400),
                  ),
                  Gap(16.w),
                  Text(
                    todayCloverCount.toString(),
                    style: AppTextStyles.subtitleMedium(
                      context,
                      color: AppColors.greenNormal,
                    ).copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              Gap(4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '오늘 완료한 미션',
                    style: AppTextStyles.subtitleMedium(
                      context,
                      color: Colors.black,
                    ).copyWith(fontWeight: FontWeight.w400),
                  ),
                  Gap(16.w),
                  Text(
                    todayFinishedMissionCount.toString(),
                    style: AppTextStyles.subtitleMedium(
                      context,
                      color: AppColors.greenNormal,
                    ).copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
