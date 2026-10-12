import 'package:flutter/material.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/month_name_form.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/weekday_name.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/circle_icon_button.dart';

// Шапка дашборда: «Сьогодні» и кнопки поиска и открытия меню уведомлений
class TodayTopBar extends StatelessWidget {
  final DateTime date;

  const TodayTopBar({required this.date, super.key});

  String _subtitle() {
    final month = GetMonthName().execute(
      month: date.month,
      form: MonthNameForm.genitive,
    );
    final weekday = GetWeekdayName().execute(
      weekday: date.weekday,
      form: WeekdayNameForm.full,
    );

    return "${date.day} $month, ${weekday.toLowerCase()}";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Сьогодні',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111936),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _subtitle(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6E7191),
              ),
            ),
          ],
        ),
        Row(
          children: [
            CircleIconButton(
              onTap: () {},
              path: 'assets/action_icons/light/search.svg',
            ),
            const SizedBox(width: 8),
            CircleIconButton(
              onTap: () {},
              path: 'assets/action_icons/light/bell.svg',
              showBadge: false,
            ),
          ],
        ),
      ],
    );
  }
}