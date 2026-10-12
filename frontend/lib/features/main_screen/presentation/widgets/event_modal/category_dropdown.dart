import 'package:flutter/material.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/event_modal/category_tile.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/event_modal/field_border.dart';

class CategoryDropdown extends StatelessWidget {
  static const Color _accent = Color(0xFF8E8BBE);
  static const Color _border = Color(0xFFE0DEEA);

  final List<Map> categories;
  final Map? value;
  final ValueChanged<Map?> onChanged;
  final String? errorText;

  const CategoryDropdown({
    required this.categories,
    required this.value,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }

  Widget _tile(Map category) {
    return CategoryTile(
      title: category["name"],
      color: hexToColor(category["color"]),
      iconPath: "assets/categories_icons/light/${category['icon']}",
      count: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Map>(
      initialValue: value,
      isExpanded: true,
      isDense: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      itemHeight: 60,
      menuMaxHeight: 260,
      borderRadius: BorderRadius.circular(18),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.keyboard_arrow_down, color: _accent),
      validator: (v) => v == null ? 'Оберіть категорію' : null,
      onChanged: onChanged,
      hint: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Оберіть категорію',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      items: [
        for (final category in categories)
          DropdownMenuItem<Map>(
            value: category,
            child: _tile(category),
          ),
      ],
      selectedItemBuilder: (context) => [
        for (final c in categories) _tile(c),
      ],
      decoration: InputDecoration(
        labelText: 'Категорія',
        labelStyle: const TextStyle(color: _accent),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 0,
        ),
        errorText: errorText,
        border: fieldBorder(_border),
        enabledBorder: fieldBorder(_border),
        focusedBorder: fieldBorder(_accent),
        errorBorder: fieldBorder(Colors.red.shade400),
        focusedErrorBorder: fieldBorder(Colors.red.shade400),
      ),
    );
  }
}