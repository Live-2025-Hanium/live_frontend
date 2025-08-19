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
    return TableCalendar(
      firstDay: type == DatePickerType.start
          ? DateTime.utc(2000, 1, 1)
          : startDate ?? DateTime.utc(2000, 1, 1),
      lastDay: type == DatePickerType.end
          ? DateTime.utc(2100, 12, 31)
          : endDate ?? DateTime.utc(2100, 12, 31),
      focusedDay: selectedDate ?? DateTime.now(),
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
