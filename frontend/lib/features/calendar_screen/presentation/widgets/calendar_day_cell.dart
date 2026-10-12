import 'package:flutter/material.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_dots.dart';

// Ячейка дня в месячном представлении календаря:
// число и под ним до 8 цветных кружков событий в виде сетки 8x2
class CalendarDayCell extends StatelessWidget {
  final Map dateData;
  final DateTime selectedDate;
  final VoidCallback onTap;

  const CalendarDayCell({
    required this.dateData,
    required this.selectedDate,
    required this.onTap,
    super.key,
  });

  bool get _isSelected {
    final DateTime date = dateData["date"];
    return date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = dateData["date"];
    final bool isCurrentMonth = dateData["is_current_month"] ?? true;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _isSelected ? const Color(0xFFFDEFE6) : Colors.transparent,
          border: Border.all(
            color: _isSelected ? const Color(0xFFFD8346) : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${date.day}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isCurrentMonth
                    ? const Color(0xFF14142B)
                    : const Color(0xFFB0B3C6),
              ),
            ),
            const SizedBox(height: 3),
            EventDots(events: (dateData["events"] as List?) ?? const []),
          ],
        ),
      ),
    );
  }
}