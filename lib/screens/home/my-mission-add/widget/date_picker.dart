import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:live_frontend/theme/app_colors.dart';

enum DatePickerType { start, end }

class DatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? startDate;
  final DateTime? endDate;
  final DatePickerType type;

  const DatePicker({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    this.startDate,
    this.endDate,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = type == DatePickerType.end && startDate != null
        ? startDate!.add(const Duration(days: 1))
        : DateTime.now();
    final lastDay = type == DatePickerType.start && endDate != null
        ? endDate!.subtract(const Duration(days: 1))
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
      onDaySelected: (selectedDay, focusedDay) {
        onDateSelected(selectedDay);
      },
      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
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
