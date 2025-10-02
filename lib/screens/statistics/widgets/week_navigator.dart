import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

/// 주간 네비게이터: "7월 둘째 주" 형태로 표시하고 좌/우로 주 단위 이동
class WeekNavigator extends StatelessWidget {
  /// 현재 기준 날짜 (필수)
  final Jiffy currentAnchor;

  /// 주 시작 요일 (기본: 월요일). DateTime.monday ~ DateTime.sunday
  final int weekStart;

  /// 주가 바뀔 때 콜백 (해당 주의 시작/끝 날짜 제공)
  final void Function(Jiffy weekStart, Jiffy weekEnd)? onChanged;

  /// 타이틀 스타일/화살표 색
  final TextStyle? titleStyle;
  final Color? arrowColor;

  const WeekNavigator({
    super.key,
    required this.currentAnchor,
    this.weekStart = DateTime.monday,
    this.onChanged,
    this.titleStyle,
    this.arrowColor,
  });

  // 달의 몇째 주인지 Jiffy 로직으로 계산
  int _calculateWeekOfMonth(Jiffy anchor) {
    // 1. 현재 날짜가 그 해의 몇째 주인지
    final currentWeekOfYear = anchor.weekOfYear;

    // 2. 현재 달의 1일이 그 해의 몇째 주인지
    final firstDayOfMonthWeekOfYear = anchor.startOf(Unit.month).weekOfYear;

    // 3. 차이 + 1
    return currentWeekOfYear - firstDayOfMonthWeekOfYear + 1;
  }

  @override
  Widget build(BuildContext context) {
    // 주차 계산
    final nth = _calculateWeekOfMonth(currentAnchor);
    final month = currentAnchor.month;
    final nthLabel = _koreanOrdinal(nth); // 첫째·둘째·셋째·…

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                // [이전 주]
                // 1. 7일을 뺀 새로운 Jiffy 객체를 만듦
                final newAnchor = currentAnchor.subtract(days: 7);

                // 2. 그 주의 시작 날짜를 구함 (startOf(Unit.WEEK)는 이미 설정된 weekStart를 따름)
                final start = newAnchor.startOf(Unit.week);

                // 3. 시작 날짜에서 6일을 더하여 끝 날짜를 구함
                final end = start.add(days: 6);

                // 콜백 호출 시 DateTime 객체로 변환
                onChanged?.call(start, end);
              },
              icon: Icon(
                Icons.chevron_left,
                size: 24,
                color: arrowColor ?? Colors.grey[400],
              ),
              tooltip: '이전 주',
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$month월 $nthLabel 주',
                style:
                    titleStyle ??
                    AppTextStyles.bodyMedium(context, color: Colors.black),
              ),
            ),
          ),
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                // [다음 주]
                // 1. 7일을 더한 새로운 Jiffy 객체를 만듦
                final newAnchor = currentAnchor.add(days: 7);

                // 2. 그 주의 시작 날짜를 구함
                final start = newAnchor.startOf(Unit.week);

                // 3. 시작 날짜에서 6일을 더하여 끝 날짜를 구함
                final end = start.add(days: 6);

                onChanged?.call(start, end);
              },
              icon: Icon(
                Icons.chevron_right,
                size: 24,
                color: arrowColor ?? Colors.grey[400],
              ),
              tooltip: '다음 주',
            ),
          ),
        ],
      ),
    );
  }
}

String _koreanOrdinal(int n) {
  switch (n) {
    case 1:
      return '첫째';
    case 2:
      return '둘째';
    case 3:
      return '셋째';
    case 4:
      return '넷째';
    case 5:
      return '다섯째';
    default:
      return '여섯째'; // 일부 달은 6주 차까지 표시될 수 있음
  }
}
