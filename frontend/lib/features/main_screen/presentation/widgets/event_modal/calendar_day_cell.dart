import 'package:flutter/material.dart';


class CalendarDayCell extends StatelessWidget {
  final Map dateData;
  final DateTime selectedDate;
  final VoidCallback onTap;

  const CalendarDayCell({
    required this.dateData,
    required this.selectedDate,
    required this.onTap,
  });

  // Цвета точек событий. Событие может быть Map с ключом "color" (Color)
  // или просто Color. Иначе используется цвет по умолчанию.
  List<Color> _eventColors() {
    final events = (dateData["events"] as List?) ?? const [];
    return events.take(3).map<Color>((e) {
      if (e is Color) return e;
      if (e is Map && e["color"] is Color) return e["color"] as Color;
      return const Color(0xFF8E24E0);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = dateData["date"] as DateTime;
    final bool isCurrentMonth = dateData["is_current_month"] as bool;
    final bool isSelected =
        date.year == selectedDate.year &&
        date.month == selectedDate.month &&
        date.day == selectedDate.day;
    final colors = _eventColors();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFE8D6) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.deepOrange.shade300, width: 1.5)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: isCurrentMonth
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: isCurrentMonth ? Colors.black87 : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              height: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final c in colors)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
