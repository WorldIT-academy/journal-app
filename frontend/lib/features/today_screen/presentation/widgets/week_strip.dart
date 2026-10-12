import 'package:flutter/material.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/grid_build.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/weekday_name.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_dots.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_time.dart';

// Полоска текущей недели
// под днями с событиями - кружки в цвет категорий
class WeekStrip extends StatelessWidget {
  final DateTime today;
  final List<Map> events;
  final List<Map> categories;
  final Map userData;

  const WeekStrip({
    required this.today,
    required this.events,
    required this.categories,
    required this.userData,
    super.key,
  });

  static const Color _textColor = Color(0xFF111936);
  static const Color _labelColor = Color(0xFFA0A3BD);
  static const Color _selectedFill = Color(0xFFFDEFE6);
  static const Color _selectedBorder = Color(0xFFFD8346);

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<DateTime> _weekDates(int? weekStart) {
    if (weekStart != null) {
      final offset = (today.weekday - weekStart + 7) % 7;
      final startDate = DateTime(today.year, today.month, today.day - offset);

      return List.generate(
        7,
        (i) => DateTime(startDate.year, startDate.month, startDate.day + i),
      );
    } else {
      final startDate = DateTime(
        today.year,
        today.month,
        today.day - (today.weekday - 1),
      );

      return List.generate(
        7,
        (i) => DateTime(startDate.year, startDate.month, startDate.day + i),
      );
    }
  }

  List<Map> _eventsFor(DateTime date) {
    // Подтягиваем категории, соответствующие каждому событию
    // чтобы сразу отображать кружки необходимого цвета
    final eventsMap = GridBuild().recieveEventsCategories(events, categories);

    return eventsMap.where((event) {
      final start = parseEventTime(event["start_at"]);
      return start != null && _isSameDay(start, date);
    }).toList();
  }

  Widget _buildDay(DateTime date) {
    final isToday = _isSameDay(date, today);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Text(
              GetWeekdayName()
                  .execute(weekday: date.weekday, form: WeekdayNameForm.short)
                  .toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _labelColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: isToday ? _selectedFill : Colors.transparent,
                border: Border.all(
                  color: isToday ? _selectedBorder : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    "${date.day}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  EventDots(events: _eventsFor(date), dotSize: 5, spacing: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: _weekDates(userData["week_start"]).map(_buildDay).toList(),
      ),
    );
  }
}
