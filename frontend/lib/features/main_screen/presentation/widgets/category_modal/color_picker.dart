import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Блок выбора цвета
class ColorPicker extends StatelessWidget {
  final List<Color> colors;
  final Color selected;
  final ValueChanged<Color> onSelected;

  const ColorPicker({
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  Color _darken(Color color) {
    // преобразуем rgb/hex в hsl
    final hsl = HSLColor.fromColor(color);

    // уменьшаем яркость для получения цвета бордера
    // .withLightness(hsl.lightness - 0.25) - снижаем яркость
    // .clamp(0.0, 1.0) - зажимаем полученный с .withLightness() цвет в диапазоне допустимых значений яркости (0.0-1.0)
    // .toColor() - преобразует полученный hsl цвет в Flutter Color объект
    return hsl.withLightness((hsl.lightness - 0.25).clamp(0.0, 1.0)).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final color in colors)
          GestureDetector(
            onTap: () => onSelected(color),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: color == selected
                    ? Border.all(color: _darken(color), width: 3)
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}
