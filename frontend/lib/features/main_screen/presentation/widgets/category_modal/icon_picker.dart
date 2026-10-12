import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Блок выбора иконки (сетка 8x2)
class IconPicker extends StatelessWidget {
  final List<String> icons;
  final String? selected;
  final Color selectedColor;
  final ValueChanged<String> onSelected;

  const IconPicker({
    required this.icons,
    required this.selected,
    required this.selectedColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // 8 колонок x 2 строки = 16 иконок
    final visibleIcons = icons.take(16).toList();

    return GridView.count(
      crossAxisCount: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 4,
      children: [
        for (final path in visibleIcons)
          GestureDetector(
            onTap: () => onSelected(path),
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              path,
              fit: BoxFit.contain,
              colorFilter: path == selected
                  ? ColorFilter.mode(selectedColor, BlendMode.srcIn)
                  : null,
            ),
          ),
      ],
    );
  }
}
