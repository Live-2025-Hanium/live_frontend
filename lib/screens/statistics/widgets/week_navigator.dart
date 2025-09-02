import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

/// 주간 네비게이터: "7월 둘째 주" 형태로 표시하고 좌/우로 주 단위 이동
class WeekNavigator extends StatelessWidget {
  /// 현재 기준 날짜 (필수)
  final DateTime currentDate;

  /// 주 시작 요일 (기본: 월요일). DateTime.monday ~ DateTime.sunday
  final int weekStart;

  /// 주가 바뀔 때 콜백 (해당 주의 시작/끝 날짜 제공)
  final void Function(DateTime weekStart, DateTime weekEnd)? onChanged;

  /// 타이틀 스타일/화살표 색
  final TextStyle? titleStyle;
  final Color? arrowColor;

  const WeekNavigator({
    super.key,
    required this.currentDate,
    this.weekStart = DateTime.monday,
    this.onChanged,
    this.titleStyle,
    this.arrowColor,
  });
  @override
  Widget build(BuildContext context) {
    final anchor = currentDate;
    final nth = _weekOfMonth(anchor, weekStart: weekStart);
    final month = anchor.month;
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
                final newAnchor = anchor.subtract(const Duration(days: 7));
                final s = _startOfWeek(newAnchor, weekStart);
                onChanged?.call(s, s.add(const Duration(days: 6)));
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
                final newAnchor = anchor.add(const Duration(days: 7));
                final s = _startOfWeek(newAnchor, weekStart);
                onChanged?.call(s, s.add(const Duration(days: 6)));
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

/// 해당 날짜가 속한 주의 "주 시작" 날짜(weekStart 기준)로 내림
DateTime _startOfWeek(DateTime d, int weekStart) {
  // DateTime.weekday: 월=1 ... 일=7
  int diff = (d.weekday - weekStart) % 7;
  if (diff < 0) diff += 7;
  final start = DateTime(d.year, d.month, d.day).subtract(Duration(days: diff));
  return DateTime(start.year, start.month, start.day); // 시간 제거
}

/// 이 달의 몇째 주인지 (월요일 시작 기준).
/// 달의 1일이 포함된 주를 "첫째 주"로 봅니다(1일이 이전달 주와 이어져도 첫째 주로 카운트).
int _weekOfMonth(DateTime d, {int weekStart = DateTime.monday}) {
  final firstOfMonth = DateTime(d.year, d.month, 1);
  final firstWeekStart = _startOfWeek(firstOfMonth, weekStart);
  final currentWeekStart = _startOfWeek(d, weekStart);
  final days = currentWeekStart.difference(firstWeekStart).inDays;
  return (days ~/ 7) + 1; // 1부터 시작
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
