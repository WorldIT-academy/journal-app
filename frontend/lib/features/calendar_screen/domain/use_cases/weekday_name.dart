enum WeekdayNameForm { short, full }

class GetWeekdayName {
  String execute({
    required int weekday,
    required WeekdayNameForm form,
    int weekStart = 1,
  }) {
    late List<String> shortNames;
    late List<String> fullNames;

    if (weekStart == 1) {
      shortNames = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'НД'];
      fullNames = [
        'Понеділок',
        'Вівторок',
        'Середа',
        'Четвер',
        'П’ятниця',
        'Субота',
        'Неділя',
      ];
    } else if (weekStart == 7) {
      shortNames = ['НД', 'ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ'];
      fullNames = [
        'Неділя',
        'Понеділок',
        'Вівторок',
        'Середа',
        'Четвер',
        'П’ятниця',
        'Субота',
      ];
    } else {
      shortNames = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'НД'];
      fullNames = [
        'Понеділок',
        'Вівторок',
        'Середа',
        'Четвер',
        'П’ятниця',
        'Субота',
        'Неділя',
      ];
    }

    switch (form) {
      case WeekdayNameForm.short:
        return shortNames[weekday - 1];

      case WeekdayNameForm.full:
        return fullNames[weekday - 1];
    }
  }
}
