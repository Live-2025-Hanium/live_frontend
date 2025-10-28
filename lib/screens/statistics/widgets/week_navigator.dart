import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:live_frontend/theme/app_colors.dart';
import 'package:live_frontend/theme/app_text_styles.dart';

/// 주간 네비게이터: "7월 둘째 주" 형태로 표시하고 좌/우로 주 단위 이동
class WeekNavigator extends StatelessWidget {
  final Jiffy currentAnchor;
  final Jiffy _today = Jiffy.now().startOf(Unit.week); // 이번 주 월요일

  /// 주가 변경될 때 호출되는 콜백 (새로운 주의 시작 날짜)
  final void Function(Jiffy weekStart) onChanged;

  WeekNavigator({
    super.key,
    required this.currentAnchor,
    required this.onChanged,
  });

  /// "해당 날짜가 속한 주"가, "그 달 기준 몇째 주인지" 계산
  int _weekOfMonth(Jiffy date) {
    // 이 달 1일
    final dt = date.dateTime;
    final firstOfMonth = DateTime(dt.year, dt.month, 1);

    // 이 달 '첫 주의 시작일' (Jiffy의 week 시작 요일 규칙을 그대로 따름: 기본 월요일)
    final firstWeekStart = Jiffy.parseFromDateTime(
      firstOfMonth,
    ).startOf(Unit.week).dateTime;

    // 현재 날짜가 속한 '주 시작일'
    final thisWeekStart = date.startOf(Unit.week).dateTime;

    // 두 주 시작일 사이의 일수 차이를 7로 나눠 주차 산정
    final diffDays = thisWeekStart.difference(firstWeekStart).inDays;
    return (diffDays ~/ 7) + 1;
  }

  String _monthWeekLabel(Jiffy date) {
    final month = date.month;
    final nth = _weekOfMonth(date);
    return '$month월 ${_koreanOrdinal(nth)} 주';
  }

  @override
  Widget build(BuildContext context) {
    final weekStart = currentAnchor.startOf(Unit.week);
    final weekEnd = currentAnchor.endOf(Unit.week);

    // 주가 한 달 안에서만 끝나면 하나만, 월 경계 걸치면 양쪽 달 라벨을 함께 표기
    final label = (weekStart.month == weekEnd.month)
        ? _monthWeekLabel(weekStart)
        : '${_monthWeekLabel(weekStart)} · ${_monthWeekLabel(weekEnd)}';

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () {
                final newAnchor = currentAnchor.subtract(days: 7);
                final start = newAnchor.startOf(Unit.week);
                onChanged.call(start);
              },
              icon: Icon(
                Icons.chevron_left,
                size: 24,
                color: AppColors.blackBlack2,
              ),
              tooltip: '이전 주',
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium(context, color: Colors.black),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: currentAnchor.isSame(_today)
                  ? null
                  : () {
                      final newAnchor = currentAnchor.add(days: 7);
                      final start = newAnchor.startOf(Unit.week);
                      onChanged.call(start);
                    },
              icon: Icon(
                Icons.chevron_right,
                size: 24,
                color: AppColors.blackBlack2,
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
    case 6:
      return '여섯째';
    default:
      return '$n째'; // 예외적으로 7주 표시 등 대비
  }
}
