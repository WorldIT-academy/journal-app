import 'package:flutter/material.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_color.dart';

// Кружки событий в цвет категории
// Общий виджет для ячейки дня (MonthView календаря) и ячейки часа (WeekView календаря)
class EventDots extends StatelessWidget {
  // Список событий, у каждого ожидается ключ "color"
  final List events;
  final double dotSize;
  final double spacing;

  // Как кружки располагаются по вертикали внутри фиксированной области
  // (start - прижать к верху, center - по центру)
  final MainAxisAlignment verticalAlignment;

  static const int maxDots = 8;
  static const int dotsPerRow = 4;

  const EventDots({
    required this.events,
    this.dotSize = 6,
    this.spacing = 3,
    this.verticalAlignment = MainAxisAlignment.start,
    super.key,
  });

  Widget _buildRow(List<Color> colors) {
    final List<Widget> children = [];

    for (int i = 0; i < colors.length; i++) {
      if (i > 0) {
        children.add(SizedBox(width: spacing));
      }
      children.add(
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(color: colors[i], shape: BoxShape.circle),
        ),
      );
    }

    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = events
        .take(maxDots)
        .map((event) => parseEventColor((event as Map)["color"]))
        .toList();

    final firstRow = colors.take(dotsPerRow).toList();
    final secondRow = colors.skip(dotsPerRow).toList();

    // Высота фиксирована (два ряда), чтобы раскладка
    // не прыгала в зависимости от количества событий
    return SizedBox(
      height: dotSize * 2 + spacing,
      child: Column(
        mainAxisAlignment: verticalAlignment,
        children: [
          if (firstRow.isNotEmpty) _buildRow(firstRow),
          if (secondRow.isNotEmpty) ...[
            SizedBox(height: spacing),
            _buildRow(secondRow),
          ],
        ],
      ),
    );
  }
}