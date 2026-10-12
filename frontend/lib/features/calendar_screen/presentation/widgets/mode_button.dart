import 'package:flutter/material.dart';
import 'package:journal_app/features/calendar_screen/presentation/screen.dart';

class ModeButton extends StatelessWidget {
  final CalendarViewMode mode;
  final bool selected;
  final VoidCallback onTap;
  final String label;

  const ModeButton({
    super.key,
    required this.mode,
    required this.selected,
    required this.onTap,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.black : Colors.black45,
            ),
          ),
        ),
      ),
    );
  }
}