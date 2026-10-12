
enum MonthNameForm {
  nominative, // серпень
  genitive,   // серпня
}

class GetMonthName {
  String execute({
    required int month,
    required MonthNameForm form,
  }) {
    const nominative = [
      'січень',
      'лютий',
      'березень',
      'квітень',
      'травень',
      'червень',
      'липень',
      'серпень',
      'вересень',
      'жовтень',
      'листопад',
      'грудень',
    ];

    const genitive = [
      'січня',
      'лютого',
      'березня',
      'квітня',
      'травня',
      'червня',
      'липня',
      'серпня',
      'вересня',
      'жовтня',
      'листопада',
      'грудня',
    ];

    switch (form) {
      case MonthNameForm.nominative:
        return nominative[month - 1];

      case MonthNameForm.genitive:
        return genitive[month - 1];
    }
  }
}
