import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/screens/home/my-mission-add/widget/selection_button.dart';
import 'package:live_frontend/screens/home/my-mission-add/widget/selection_tile.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/screens/home/my-mission-add/widget/date_picker.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';
import 'package:go_router/go_router.dart';

class MyMissionAddScreen extends StatefulWidget {
  const MyMissionAddScreen({super.key});

  @override
  State<MyMissionAddScreen> createState() => _MyMissionAddScreenState();
}

class _MyMissionAddScreenState extends State<MyMissionAddScreen> {
  late MyMissionAddModel _mission;
  late List<bool> _included;

  @override
  void initState() {
    super.initState();
    _mission = MyMissionAddModel(
      missionTitle: null,
      startDate: null,
      endDate: null,
      scheduledTime: null,
      repeatDay: null,
    );
    _included = [false, false, false, false]; // 초기 선택 여부 설정
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaeipAppBar(title: '마이 미션 추가'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 24.h,
        ), // 기본 하단 패딩이 16임
        child: SizedBox(
          width: double.infinity,
          height: 48.h,
          child: SaeipButton(text: '저장', onPressed: () {}),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.blackBlack0,
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 120.h),
          child: ListView(
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
              SelectionTile(
                title: '시작일',
                selected: _dateToFormat(_mission.startDate),
                include: _included[0],
                onToggle: (value) {
                  setState(() {
                    _included[0] = value;
                  });
                },
                child: DatePicker(
                  type: DatePickerType.start,
                  startDate: _mission.startDate,
                  endDate: _mission.endDate,
                  selectedDate: _mission.startDate,
                  onDateSelected: (date) {
                    setState(() {
                      _mission.startDate = date;
                    });
                  },
                ),
              ),
              Gap(16.h),
              SelectionTile(
                title: '종료일',
                selected: _dateToFormat(_mission.endDate),
                include: _included[1],
                onToggle: (value) {
                  setState(() {
                    _included[1] = value;
                  });
                },
                child: DatePicker(
                  type: DatePickerType.end,
                  startDate: _mission.startDate,
                  endDate: _mission.endDate,
                  selectedDate: _mission.endDate,
                  onDateSelected: (date) {
                    setState(() {
                      _mission.endDate = date;
                    });
                  },
                ),
              ),
              Gap(16.h),
              SelectionTile(
                title: '시간   ',
                selected: _mission.scheduledTime,
                include: _included[2],
                onToggle: (value) {
                  setState(() {
                    _included[2] = value;
                  });
                },
                child: TimePickerSpinner(
                  locale: const Locale('en', ''),
                  time: MyMissionAddModel.parseTime(
                    _mission.scheduledTime ?? '',
                  ),
                  is24HourMode: false,
                  itemHeight: 70,
                  spacing: 25,
                  normalTextStyle: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.blackBlack5,
                  ),
                  highlightedTextStyle: AppTextStyles.subtitleMedium(
                    context,
                    color: Colors.black,
                  ),
                  isForce2Digits: true,
                  onTimeChange: (time) {
                    setState(() {
                      _mission.scheduledTime = MyMissionAddModel.formatTime(
                        time,
                      );
                    });
                  },
                ),
              ),
              Gap(16.h),
              SelectionButton(
                title: '반복',
                selected: _mission.repeatDay?.label,
                include: _included[3],
                onToggle: (value) {
                  setState(() {
                    _included[3] = value;
                  });
                },
                onPressed: () async {
                  final result = await context.pushNamed(
                    'repeat',
                    extra: _mission.repeatDay,
                  );
                  if (result != null && result is RepeatDay) {
                    setState(() {
                      _mission.repeatDay = result;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _dateToFormat(DateTime? date) {
    if (date == null) {
      return null;
    } else if (Jiffy.parseFromDateTime(
      date,
    ).isSame(Jiffy.now(), unit: Unit.day)) {
      return '오늘';
    }
    return Jiffy.parseFromDateTime(date).format(pattern: 'M월 d일');
  }
}
