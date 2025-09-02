import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:live_frontend/theme/app_colors.dart';

enum DatePickerType { start, end }

class DatePicker extends StatelessWidget {
  final DatePickerType type;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DatePicker({
    super.key,
    required this.type,
    this.startDate,
    this.endDate,
    this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    // compute valid range
    final firstDay = (type == DatePickerType.end && startDate != null)
        ? startDate!
        : DateTime.now();
    final lastDay = (type == DatePickerType.start && endDate != null)
        ? endDate!
        : DateTime.utc(2100, 12, 31);

    DateTime focusedDay = selectedDate ?? DateTime.now();
    if (focusedDay.isBefore(firstDay)) focusedDay = firstDay;
    if (focusedDay.isAfter(lastDay)) focusedDay = lastDay;

    return TableCalendar(
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate: (day) =>
          selectedDate != null && isSameDay(day, selectedDate),
      onDaySelected: (selectedDay, _) => onDateSelected(selectedDay),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: AppColors.greenDarker,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AppColors.greenNormal,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
