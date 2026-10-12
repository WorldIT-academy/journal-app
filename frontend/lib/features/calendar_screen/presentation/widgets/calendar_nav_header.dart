import 'package:flutter/material.dart';
import 'package:journal_app/features/calendar_screen/presentation/screen.dart';
import 'nav_arrow_button.dart';
import 'today_button.dart';

class CalendarNavHeader extends StatelessWidget {
  final DateTime referenceDate;
  final DateTime selectedDate;
  final String currentMonthText;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onToday;
  final VoidCallback onNextWeek;
  final VoidCallback onPreviousWeek;
  final CalendarViewMode mode;
  final bool isDayView;

  const CalendarNavHeader({
    super.key,
    required this.referenceDate,
    required this.currentMonthText,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onToday,
    required this.onNextWeek,
    required this.onPreviousWeek,
    required this.mode,
    required this.isDayView,
    required this.selectedDate,

  });

  void onNext() {
    if (mode == CalendarViewMode.month) {
      onNextMonth();
    } else if (mode == CalendarViewMode.week) {
      onNextWeek();
    }
  }

  void onPrevious() {
    if (mode == CalendarViewMode.month) {
      onPreviousMonth();
    } else if (mode == CalendarViewMode.week) {
      onPreviousWeek();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (!isDayView)
              NavArrowButton(
                onTap: onPrevious,
                path: 'assets/action_icons/light/chevron-left.svg',
              ),
            if (!isDayView) const SizedBox(width: 8),
            Text(
              isDayView ? "${selectedDate.day} $currentMonthText ${selectedDate.year}" : "$currentMonthText ${referenceDate.year}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            if (!isDayView) NavArrowButton(
              onTap: onNext,
              path: 'assets/action_icons/light/chevron-right.svg',
            ),
          ],
        ),
        if (!isDayView) TodayButton(onTap: onToday),
      ],
    );
  }
}
