import 'package:flutter/material.dart';

class WeekDaysRow extends StatelessWidget {
  final int weekStart;
  late List<String> _days;

  WeekDaysRow(this.weekStart);

  @override
  Widget build(BuildContext context) {
    if (weekStart == 1) {
      _days = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'НД'];
    } else if (weekStart == 7) {
      _days = ['НД', 'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ'];
    } else {
      _days = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'НД'];
    }

    return Row(
      children: [
        for (final day in _days)
          Expanded(
            child: Center(
              child: Text(
                day,
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }
}
