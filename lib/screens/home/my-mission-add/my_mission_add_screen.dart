import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/models/my_mission_model.dart';
import 'package:live_frontend/models/mission_models.dart';
import 'package:live_frontend/providers/home_provider.dart';
import 'package:live_frontend/screens/home/my-mission-add/widget/selection_button.dart';
import 'package:live_frontend/screens/home/my-mission-add/widget/selection_tile.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';
import 'package:live_frontend/widgets/saeip_app_bar.dart';
import 'package:live_frontend/screens/home/my-mission-add/widget/date_picker.dart';
import 'package:live_frontend/widgets/saeip_button.dart';
import 'package:live_frontend/widgets/utils/show_saeip_toast.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';
import 'package:go_router/go_router.dart';

class MyMissionAddScreen extends ConsumerStatefulWidget {
  const MyMissionAddScreen({super.key});

  @override
  ConsumerState<MyMissionAddScreen> createState() => _MyMissionAddScreenState();
}

class _MyMissionAddScreenState extends ConsumerState<MyMissionAddScreen> {
  late MyMissionAddModel _mission;
  late List<bool> _included;

  // 1) TextField controller로 값 관리
  late final TextEditingController _titleController;

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
    _included = [false, false, false, false]; // 시작일, 종료일, 시간, 반복
    _titleController = TextEditingController(text: _mission.missionTitle ?? '');
    _titleController.addListener(() {
      _mission.missionTitle = _titleController.text;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // 3) _included에 따라 실제 존재하는지 판단하는 getter
  bool get _effectiveStartPresent => _included[0] && _mission.startDate != null;
  bool get _effectiveEndPresent => _included[1] && _mission.endDate != null;

  void _showError(String message) {
    SaeipToastController.showMessage(context, message);
  }

  // 2) 버튼 클릭 시 validation
  bool _validateBeforeSave() {
    final title = _titleController.text.trim();
    if (title.length < 2) {
      _showError('제목을 두 글자 이상 입력해주세요.');
      return false;
    }

    // 시작/종료는 각각 _included가 false면 "없음"으로 간주
    // 둘 중 하나만 존재하면 에러
    if (_effectiveStartPresent != _effectiveEndPresent) {
      if (!_effectiveStartPresent && _effectiveEndPresent) {
        _showError('시작일을 선택해주세요.');
      } else if (_effectiveStartPresent && !_effectiveEndPresent) {
        _showError('종료일을 선택해주세요.');
      }
      return false;
    }
    if (_included[0] && _mission.startDate == null) {
      _showError('시작일을 선택해주세요.');
      return false;
    }
    if (_included[1] && _mission.endDate == null) {
      _showError('종료일을 선택해주세요.');
      return false;
    }
    if (_included[2] && _mission.scheduledTime == null) {
      _showError('시간을 선택해주세요.');
      return false;
    }
    if (_included[3] && _mission.repeatDay == null) {
      _showError('반복 설정을 선택해주세요.');
      return false;
    }

    // 시작일이 종료일보다 늦으면 에러
    if (_effectiveStartPresent &&
        _effectiveEndPresent &&
        _mission.startDate!.isAfter(_mission.endDate!)) {
      _showError('시작일은 종료일보다 이전이어야 합니다.');
      return false;
    }
    return true;
  }

  Future<void> _onSavePressed() async {
    if (!_validateBeforeSave()) return;

    // Build MyMissionModel and add to global state
    final scheduledTime = _included[2] ? (_mission.scheduledTime) : null;
    final repeatDay = _included[3] && _mission.repeatDay != null
        ? _mission.repeatDay!
        : null;

    final newMission = MyMissionModel(
      userMissionId: DateTime.now().millisecondsSinceEpoch,
      missionType: MissionType.my,
      missionTitle: _titleController.text.trim(),
      missionStatus: MissionStatus.assigned,
      scheduledTime: scheduledTime,
      repeatDay: repeatDay,
    );

    try {
      await ref
          .read(myMissionNotifierProvider.notifier)
          .addMyMission(newMission);
      if (!mounted) return;
      SaeipToastController.showMessage(context, '마이 미션이 추가되었습니다.');
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      SaeipToastController.showMessage(context, '저장에 실패했습니다.');
    }
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
          child: SaeipButton(text: '저장', onPressed: _onSavePressed),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.blackBlack0,
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 120.h),
          child: ListView(
            children: [
              TextField(
                controller: _titleController,
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
                      color: AppColors.greenLightActive,
                      width: 1.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide(
                      color: AppColors.greenLightActive,
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
                    _included[1] = value;
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
                    _included[0] = value;
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
                title: '반복   ',
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
                    queryParameters: _mission.repeatDay != null
                        ? {
                            'initial': _mission.repeatDay
                                .toString()
                                .split('.')
                                .last,
                          }
                        : {},
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
