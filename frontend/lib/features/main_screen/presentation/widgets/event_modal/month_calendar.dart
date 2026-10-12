import 'package:flutter/material.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/calendar_day_cell.dart';

class MonthCalendar extends StatelessWidget {
  final List<Map> gridList;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const MonthCalendar({
    required this.gridList,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.85,
      ),
      itemCount: gridList.length,
      itemBuilder: (context, index) {
        final Map dateData = gridList[index];
        return CalendarDayCell(
          dateData: dateData,
          selectedDate: selectedDate,
          onTap: () => onDateSelected(dateData["date"] as DateTime),
        );
      },
    );
  }
}
