import 'package:intl/intl.dart';

class GridBuild {
  List<Map>? execute(
    String action,
    DateTime referenceDate,
    List<Map> events,
    List<Map> categories,
    int weekStart,
  ) {
    if (action == "build_month_grid") {
      return _buildMonthGrid(referenceDate, events, categories, weekStart);
    } else if (action == "build_week_grid") {
      return _buildWeekGrid(referenceDate, events, categories, weekStart);
    } else if (action == "build_day_grid") {
      return _buildDayGrid(referenceDate, events, categories);
    }

    return _buildMonthGrid(referenceDate, events, categories, weekStart);
  }

  List<Map> _buildMonthGrid(
    DateTime referenceDate,
    List<Map> events,
    List<Map> categories,
    int weekStart,
  ) {
    final firstDayOfMonth = DateTime(
      referenceDate.year,
      referenceDate.month,
      1,
    );

    final firstDayWeekday = firstDayOfMonth.weekday;
    final offset = (firstDayWeekday - weekStart + 7) % 7;
    final gridStart = DateTime(firstDayOfMonth.year, firstDayOfMonth.month, firstDayOfMonth.day - offset);

    List<DateTime> gridDates = List.generate(
      42,
      (index) =>
          DateTime(gridStart.year, gridStart.month, gridStart.day + index),
    );

    List<Map> monthGridList = [];

    events = recieveEventsCategories(events, categories);

    for (DateTime date in gridDates) {
      List<Map> dateEvents = [];

      for (Map event in events) {
        final eventData = parseDate(event["start_at"]);

        if (eventData.year == date.year &&
            eventData.month == date.month &&
            eventData.day == date.day) {
          dateEvents.add(event);
        }
      }

      monthGridList.add({
        "date": date,
        "is_current_month":
            date.year == referenceDate.year &&
            date.month == referenceDate.month,
        "events": dateEvents,
      });
    }

    return monthGridList;
  }

  List<Map> recieveEventsCategories(List<Map> events, List<Map> categories) {
    Map categoriesMap = {};

    for (Map category in categories) {
      categoriesMap[category["id"]] = category;
    }

    for (int i = 0; i < events.length; i++) {
      Map eventData = events[i];
      Map? categoryData = categoriesMap[eventData["category_id"]];

      if (categoryData != null) {
        if (eventData["category_id"] == categoryData["id"]) {
          eventData.remove("category_id");
          eventData["color"] = categoryData["color"];
          eventData["icon"] = categoryData["icon"];
          eventData["name"] = categoryData["name"];
        }
      }
    }

    return events;
  }

  // Преобразует строку с датой в объект DateTime
  DateTime parseDate(String date) {
    return DateFormat(
      "EEE, dd MMM yyyy HH:mm:ss 'GMT'",
      'en_US',
    ).parseUtc(date);
  }

  // Прогоняем полученную дату через parseDate - метод,
  //который преобразует строку с датой в объект Datetime
  DateTime parseWallClock(String date) {
    final utc = parseDate(date);

    // Часовой пояс не применяем, да-бы не съезжали события со своих точек
    // (в данной версии проекта не предусматривается учет часового пояса)
    return DateTime(
      utc.year,
      utc.month,
      utc.day,
      utc.hour,
      utc.minute,
      utc.second,
    );
  }

  List<Map> _buildWeekGrid(
    DateTime referenceDate,
    List<Map> events,
    List<Map> categories,
    int weekStart,
  ) {
    
    final date = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );

    final offset = (date.weekday - weekStart + 7) % 7;
    final weekStartDate = DateTime(date.year, date.month, date.day - offset);

    final List<DateTime> weekDates = List.generate(
      7,
      (index) =>
          DateTime(weekStartDate.year, weekStartDate.month, weekStartDate.day + index),
    );

    events = recieveEventsCategories(events, categories);

    final List<Map> weekGridList = [];

    for (final dateElement in weekDates) {
      // Все события целиком лежат внутри одного дня,
      // поэтому достаточно сравнить лишь день начала
      final List<Map> dateEvents = events.where((event) {
        final start = parseWallClock(event["start_at"]);

        return start.year == dateElement.year &&
            start.month == dateElement.month &&
            start.day == dateElement.day;
      }).toList();

      weekGridList.add({"date": dateElement, "events": dateEvents});
    }

    return weekGridList;
  }

  List<Map> _buildDayGrid(
    DateTime referenceDate,
    List<Map> events,
    List<Map> categories,
  ) {
    // DateTime(y, m, d, hour) вместо date.add(Duration(hours)):
    // так сетка всегда состоит ровно из 24 часов, даже в день перевода часов
    final List<DateTime> dayHours = List.generate(
      24,
      (hour) => DateTime(
        referenceDate.year,
        referenceDate.month,
        referenceDate.day,
        hour,
      ),
    );

    events = recieveEventsCategories(events, categories);

    final List<Map> dayGridList = [];

    for (final hourStart in dayHours) {
      final hourEnd = DateTime(
        hourStart.year,
        hourStart.month,
        hourStart.day,
        hourStart.hour + 1,
      );

      // В час попадают только события, чей диапазон start_at..end_at
      // захватывает этот час (последний час включается)
      final List<Map> hourEvents = events.where((event) {
        final start = parseWallClock(event["start_at"]);
        final end = event["end_at"] != null
            ? parseWallClock(event["end_at"])
            : start;

        return start.isBefore(hourEnd) && !end.isBefore(hourStart);
      }).toList();

      dayGridList.add({"date": hourStart, "events": hourEvents});
    }

    return dayGridList;
  }
}
