import 'package:flutter/material.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_card.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_time.dart';

class EventsContainer extends StatelessWidget {
  final String currentDateText;
  final String currentWeekday;
  final String currentDayEventsCount;

  // События выбранного дня
  final List<Map> events;

  // Нажатие на карточку события (например, открыть детали)
  final void Function(Map event)? onEventTap;

  const EventsContainer({
    super.key,
    required this.currentDateText,
    required this.currentWeekday,
    required this.currentDayEventsCount,
    this.events = const [],
    this.onEventTap,
  });

  // Сортировка по времени начала: утренние события сверху
  List<Map> _sortedEvents() {
    final sorted = List<Map>.from(events);
    sorted.sort((a, b) {
      final aStart = parseEventTime(a["start_at"]);
      final bStart = parseEventTime(b["start_at"]);
      if (aStart == null || bStart == null) {
        return 0;
      }
      return aStart.compareTo(bStart);
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final sortedEvents = _sortedEvents();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentDateText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            Text(
              "$currentWeekday, $currentDayEventsCount подій",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black45,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < sortedEvents.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          EventCard(
            event: sortedEvents[i],
            onTap: onEventTap == null
                ? null
                : () => onEventTap!(sortedEvents[i]),
          ),
        ],
      ],
    );
  }
}