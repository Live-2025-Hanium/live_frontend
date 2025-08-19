import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:live_frontend/screens/home/my-mission-add/widget/selection_tile.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';

class MyMissionAddScreen extends StatefulWidget {
  const MyMissionAddScreen({super.key});

  @override
  State<MyMissionAddScreen> createState() => _MyMissionAddScreenState();
}

class _MyMissionAddScreenState extends State<MyMissionAddScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: '마이 미션 추가'),
      body: SafeArea(
        child: Container(
          color: AppColors.blackBlack0,
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 40.h),
          child: Column(
            children: [
              TextField(
                style: AppTextStyles.bodyRegular(context, color: Colors.black),
                decoration: InputDecoration(
                  hintText: '제목',
                  hintStyle: AppTextStyles.bodyRegular(
                    context,
                    color: AppColors.blackBlack4,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(
                      color: AppColors.greenLightActive, // 비활성(포커스X)일 때 색상
                      width: 1.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(
                      color: AppColors.greenLightActive, // 포커스일 때 색상
                      width: 1.w,
                    ),
                  ),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
              ),
              Gap(16.h),
              SelectionTile(title: '시작일', selected: '2023-01-01'),
              Gap(16.h),
              SelectionTile(title: '종료일', selected: '2023-01-01'),
              Gap(16.h),
              SelectionTile(title: '시간', selected: '09:00'),
              Gap(16.h),
              SelectionTile(title: '반복', selected: '매일'),
            ],
          ),
        ),
      ),
    );
  }
}
