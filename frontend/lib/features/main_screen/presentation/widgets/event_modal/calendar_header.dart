import 'package:flutter/material.dart';


class CalendarHeader extends StatelessWidget {
  static const List<String> _monthNames = [
    'Січень',
    'Лютий',
    'Березень',
    'Квітень',
    'Травень',
    'Червень',
    'Липень',
    'Серпень',
    'Вересень',
    'Жовтень',
    'Листопад',
    'Грудень',
  ];

  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;

  const CalendarHeader({
    required this.month,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
  });

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE0DEEA)),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _arrowButton(Icons.chevron_left, onPrev),
        const SizedBox(width: 12),
        Text(
          '${_monthNames[month.month - 1]} ${month.year}',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 12),
        _arrowButton(Icons.chevron_right, onNext),
        const Spacer(),
        GestureDetector(
          onTap: onToday,
          child: Container(
            height: 26,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE0DEEA)),
            ),
            child: const Text('Сьогодні', style: TextStyle(fontSize: 11)),
          ),
        ),
      ],
    );
  }
}
