

import 'package:journal_app/features/main_screen/domain/repositories/event_repository.dart';

class MainScreenEventUseCase {
  final MainScreenEventRepository repository;

  MainScreenEventUseCase({required this.repository});

  Future<Map<String, dynamic>> sendCreateCategoryRequest(Map<String, dynamic> enteredData, String? session) async {
    return await repository.sendCreateEventRequest(enteredData, session);
  }

  Future<Map<String, dynamic>> sendGetEventsRequest(String? session) async {
    return await repository.getEvents(session);
  }
  
  List<Map> buildMonthGrid(DateTime referenceDate, int weekStart) {
    final firstDayOfMonth = DateTime(
      referenceDate.year,
      referenceDate.month,
      1,
    );

    final firstDayWeekday = firstDayOfMonth.weekday;
    final offset = (firstDayWeekday - weekStart + 7) % 7;
    final gridStart = DateTime(firstDayOfMonth.year, firstDayOfMonth.month, firstDayOfMonth.day - offset);

    final List<DateTime> gridDates = List.generate(
      42,
      (index) =>
          DateTime(gridStart.year, gridStart.month, gridStart.day + index),
    );

    final List<Map> monthGridList = [];

    for (final DateTime date in gridDates) {
      monthGridList.add({
        "date": date,
        "is_current_month":
            date.year == referenceDate.year &&
            date.month == referenceDate.month,
        "events": [],
      });
    }

    return monthGridList;
  }
}
