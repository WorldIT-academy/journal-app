import 'package:flutter/material.dart';

// Принимает Color, int (0xAARRGGBB) или hex-строку ("#RRGGBB" / "RRGGBB" / "AARRGGBB")
// Если цвет указан неверно, или его не удалось разобрать - возвращает серый
Color parseEventColor(dynamic value) {
  if (value is Color) {
    return value;
  }
  if (value is int) {
    return Color(value);
  }
  if (value is String) {
    var hex = value.replaceAll('#', '').trim();
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    final parsed = int.tryParse(hex, radix: 16);
    if (parsed != null) {
      return Color(parsed);
    }
  }
  return Colors.grey;
}