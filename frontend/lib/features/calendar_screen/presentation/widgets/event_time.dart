import 'package:intl/intl.dart';

// Парсим время и строчного формата в формат DateTime
// Часовой пояс не применяем, иначе события съедут на смещение устройства
DateTime? parseEventTime(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is DateTime) {
    return value;
  }

  try {
    final utc = DateFormat(
      "EEE, dd MMM yyyy HH:mm:ss 'GMT'",
      'en_US',
    ).parseUtc(value as String);

    return DateTime(
      utc.year,
      utc.month,
      utc.day,
      utc.hour,
      utc.minute,
      utc.second,
    );
  } catch (_) {
    return null;
  }
}

// Смена формата времени с 9:5 на 09:05
// очевидно, для корректного отображения в интерфейсе
String formatHourMinute(DateTime? time) {
  if (time == null) {
    return "--:--";
  }
  final hour = time.hour.toString().padLeft(2, "0");
  final minute = time.minute.toString().padLeft(2, "0");
  return "$hour:$minute";
}
