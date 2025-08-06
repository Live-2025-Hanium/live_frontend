import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/widgets/saeip_button.dart';

class MissionRecordScreen extends StatelessWidget {
  const MissionRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: '미션 기록'),
      body: Container(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 40.h),
        width: double.infinity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: SizedBox(
                      width: 124.w,
                      height: 124.w,
                      child: Image.asset(
                        'assets/images/clover_mission_complete.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48.w,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        '사진 촬영',
                        style: AppTextStyles.smallMedium(
                          context,
                          color: AppColors.blackBlack4,
                        ).copyWith(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  Text(
                    '미션 제목',
                    style: AppTextStyles.titleMedium(
                      context,
                      color: Colors.black,
                    ),
                  ),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      fillColor: AppColors.blackBlack0,
                      filled: true,
                      hintText: '미션을 완료하고 기분이 어땠나요?',
                      hintStyle: AppTextStyles.bodyRegular(
                        context,
                        color: AppColors.blackBlack4,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: SaeipButton(text: '저장', onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
