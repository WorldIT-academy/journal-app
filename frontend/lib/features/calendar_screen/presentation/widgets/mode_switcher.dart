import 'package:flutter/material.dart';
import 'package:journal_app/features/calendar_screen/presentation/screen.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/mode_button.dart';

class ModeSwitcher extends StatelessWidget {
  final CalendarViewMode mode;
  final ValueChanged<CalendarViewMode> onModeSelected;

  const ModeSwitcher({
    super.key,
    required this.mode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ModeButton(
            mode: CalendarViewMode.month,
            selected: mode == CalendarViewMode.month,
            label: 'Місяць',
            onTap: () => onModeSelected(CalendarViewMode.month),
          ),
          ModeButton(
            mode: CalendarViewMode.week,
            selected: mode == CalendarViewMode.week,
            label: 'Тиждень',
            onTap: () => onModeSelected(CalendarViewMode.week),
          ),
          ModeButton(
            mode: CalendarViewMode.day,
            selected: mode == CalendarViewMode.day,
            label: 'День',
            onTap: () => onModeSelected(CalendarViewMode.day),
          ),
        ],
      ),
    );
  }
}