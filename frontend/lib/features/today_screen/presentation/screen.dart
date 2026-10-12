import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/event_use_case.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_card.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_details_modal.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_time.dart';
import 'package:journal_app/features/today_screen/presentation/widgets/section_header.dart';
import 'package:journal_app/features/today_screen/presentation/widgets/stat_card.dart';
import 'package:journal_app/features/today_screen/presentation/widgets/today_top_bar.dart';
import 'package:journal_app/features/today_screen/presentation/widgets/week_strip.dart';

class TodayScreen extends StatefulWidget {
  final List<Map> events;
  final List<Map> categories;
  final Map userData;

  // Удаление события: запрос на сервер и удаление из общего списка
  final CalendarScreenEventUseCase calendarScreenEventUseCase;
  final FlutterSecureStorage storage;
  final void Function(int id)? removeEvent;

  // Нажатие на «Всі події» - переход на вкладку календаря
  final VoidCallback? onAllEventsTap;

  const TodayScreen({
    required this.events,
    required this.categories,
    required this.calendarScreenEventUseCase,
    required this.storage,
    required this.removeEvent,
    required this.userData,
    this.onAllEventsTap,
    super.key,
  });

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  // До какого часа считаем «свободное время» на сегодня
  static const int dayEndHour = 22;

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Открытие модалки с деталями события и его удаление
  void _onEventTap(Map event) {
    showEventDetailsModal(
      context,
      event: event,
      onDelete: (event) async {
        final session = await widget.storage.read(key: "session");

        final result = await widget.calendarScreenEventUseCase
            .sendEventDeleteRequest(event["id"], session);

        if (result["success"] != true) {
          // Модалка покажет «Не вдалося видалити подію» и останется открытой
          throw Exception("Event delete failed");
        }

        widget.removeEvent?.call(event["id"]);

        if (mounted) {
          // Все данные экрана считаются в build из widget.events,
          // поэтому достаточно просто перерисовать экран
          setState(() {});

          // Закрываем модалку
          Navigator.pop(context, true);
        }
      },
    );
  }

  // События сегодняшнего дня с уже разобранным временем,
  // по возрастанию времени начала события (start_at)
  List<({Map event, DateTime start, DateTime end})> _todayEvents(DateTime now) {
    final result = <({Map event, DateTime start, DateTime end})>[];

    for (final event in widget.events) {
      final start = parseEventTime(event["start_at"]);
      if (start == null || !_isSameDay(start, now)) {
        continue;
      }
      final end = parseEventTime(event["end_at"]) ?? start;
      result.add((event: event, start: start, end: end));
    }

    result.sort((a, b) => a.start.compareTo(b.start));

    return result;
  }

  // Свободное время от «сейчас» до dayEndHour минус оставшиеся события (их временные промежутки)
  Duration _freeTimeLeft(
    DateTime now,
    List<({Map event, DateTime start, DateTime end})> todayEvents,
  ) {
    final dayEnd = DateTime(now.year, now.month, now.day, dayEndHour);
    if (!now.isBefore(dayEnd)) {
      return Duration.zero;
    }

    var busy = Duration.zero;
    for (final event in todayEvents) {
      // Учитываем только часть события между «сейчас» и концом дня
      final from = event.start.isAfter(now) ? event.start : now;
      final to = event.end.isBefore(dayEnd) ? event.end : dayEnd;
      if (to.isAfter(from)) {
        busy += to.difference(from);
      }
    }

    final free = dayEnd.difference(now) - busy;
    return free.isNegative ? Duration.zero : free;
  }

  String _formatFreeTime(Duration free) {
    if (free.inHours >= 1) {
      return "${free.inHours} год";
    }
    return "${free.inMinutes} хв";
  }

  // Подсчет времени до ближайшего события
  String _startsInText(DateTime start, DateTime now) {
    final diff = start.difference(now);

    if (diff.inMinutes <= 0) {
      return "Зараз";
    }
    if (diff.inMinutes < 60) {
      return "Через ${diff.inMinutes} хв";
    }

    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    return minutes == 0 ? "Через $hours год" : "Через $hours год $minutes хв";
  }

  Widget _buildEmptyHint(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, color: Color(0xFF6E7191)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayEvents = _todayEvents(now);

    // Ещё не закончившиеся события: идущее сейчас тоже считается «найближчим»
    final upcoming = todayEvents.where((e) => e.end.isAfter(now)).toList();
    final nearest = upcoming.isEmpty ? null : upcoming.first;
    final nextEvents = upcoming.skip(1).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TodayTopBar(date: now),
              const SizedBox(height: 20),
              WeekStrip(
                today: now,
                events: widget.events,
                categories: widget.categories,
                userData: widget.userData
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.calendar_today_outlined,
                      color: const Color(0xFF7C3AED),
                      value: todayEvents.length.toString(),
                      label: "події",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.access_time_rounded,
                      color: const Color(0xFFFD8346),
                      value: _formatFreeTime(_freeTimeLeft(now, todayEvents)),
                      label: "вільно",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
              SectionHeader(
                title: "Найближча подія",
                trailingText: nearest == null
                    ? null
                    : _startsInText(nearest.start, now),
              ),
              const SizedBox(height: 12),
              if (nearest == null)
                _buildEmptyHint("На сьогодні подій більше немає")
              else
                EventCard(
                  event: nearest.event,
                  onTap: () => _onEventTap(nearest.event),
                ),

              const SizedBox(height: 28),

              SectionHeader(
                title: "Наступні події",
                trailingText: "Всі події",
                showChevron: true,
                onTrailingTap: widget.onAllEventsTap,
              ),
              const SizedBox(height: 12),
              if (nextEvents.isEmpty)
                _buildEmptyHint("Більше подій сьогодні немає")
              else
                for (int i = 0; i < nextEvents.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  EventCard(
                    event: nextEvents[i].event,
                    onTap: () => _onEventTap(nextEvents[i].event),
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}