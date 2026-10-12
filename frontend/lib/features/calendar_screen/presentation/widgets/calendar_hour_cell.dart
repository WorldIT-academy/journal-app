import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_dots.dart';

class CalendarHourCell extends StatelessWidget {
  final VoidCallback onTap;

  // Начало часа, который представляет конкретная клетка (например, 2026-10-05 13:00)
  final DateTime hourStart;

  // Все события дня
  final List events;

  const CalendarHourCell({
    super.key,
    required this.onTap,
    required this.hourStart,
    this.events = const [],
  });

  // Парсинг даты из строчного формата в формат DateTime-объекта
  DateTime _parse(dynamic value) {
    if (value is DateTime) {
      return value;
    }

    final utc = DateFormat(
      "EEE, dd MMM yyyy HH:mm:ss 'GMT'",
      'en_US',
    ).parseUtc(value as String);

    // Пересобираем как локальное время с теми же часами и минутами
    // без учета часового пояса
    return DateTime(
      utc.year,
      utc.month,
      utc.day,
      utc.hour,
      utc.minute,
      utc.second,
    );
  }

  // Метод для отображения событий, который происходят в пределах одного часа
  // чтобы они тоже отображались, пусть и в одной лишь клетке
  bool _coversThisHour(Map event) {
    final hourEnd = DateTime(
      hourStart.year,
      hourStart.month,
      hourStart.day,
      hourStart.hour + 1,
    );

    final start = _parse(event["start_at"]);
    var end = event["end_at"] != null ? _parse(event["end_at"]) : start;

    // Событие без длительности считаем минутным, чтобы оно не пропало
    if (!end.isAfter(start)) {
      end = start.add(const Duration(minutes: 1));
    }

    return start.isBefore(hourEnd) && !end.isBefore(hourStart);
  }

  @override
  Widget build(BuildContext context) {
    final hourEvents = events
        .where((event) => _coversThisHour(event as Map))
        .toList();

    return SizedBox(
      width: 40,
      height: 40,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(color: Color.fromARGB(255, 239, 238, 243)),
          ),
        ),
        child: EventDots(
          events: hourEvents,
          verticalAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}