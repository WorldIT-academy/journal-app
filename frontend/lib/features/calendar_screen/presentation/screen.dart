import 'package:flutter/material.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/event_use_case.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/grid_build.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/month_name_form.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/weekday_name.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/calendar_day_cell.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/calendar_hour_cell.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/calendar_nav_header.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_details_modal.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_pill.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/events_container.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/mode_switcher.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/top_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum CalendarViewMode { month, week, day }

class CalendarScreen extends StatefulWidget {
  final List<Map> categories;
  final FlutterSecureStorage storage;

  // Events
  final List<Map> events;
  final CalendarScreenEventUseCase calendarScreenEventUseCase;
  final void Function(int id)? removeEvent;

  // User data
  final Map userData;

  const CalendarScreen({
    required this.events,
    required this.categories,
    required this.calendarScreenEventUseCase,
    required this.storage,
    required this.removeEvent,
    required this.userData,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Use cases
  final GridBuild gridBuildUseCase = GridBuild();
  final GetMonthName getMonthNameUseCase = GetMonthName();
  final GetWeekdayName getWeekdayNameUseCase = GetWeekdayName();

  // Current day
  DateTime _selectedDate = DateTime.now();
  late String currentMonthText;
  late String currentDateText;
  late String currentWeekday;
  late String currentDayEventsCount;
  List<Map> currentDayEvents = [];

  // Представление календаря,
  // которое было выбрано (месяц, неделя, день)
  CalendarViewMode _mode = CalendarViewMode.month;

  // Не текущий день.
  // Это опорная дата для отображения месяца
  DateTime _referenceDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    currentMonthText = capitalize(
      getMonthNameUseCase.execute(
        month: _referenceDate.month,
        form: MonthNameForm.nominative,
      ),
    );

    setCurrentDateData(_dayDataFor(_selectedDate));
  }

  // Если обновился родитель (главный родитель - MyHomePage)
  // Тогда обновится и текущий виджет (CalendarScreen)
  // didUpdateWidget отследит setState у родителя и отработает
  @override
  void didUpdateWidget(covariant CalendarScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    setCurrentDateData(_dayDataFor(_selectedDate));
  }

  Map _dayDataFor(DateTime date) {
    final grid =
        gridBuildUseCase.execute(
          "build_month_grid",
          date,
          widget.events,
          widget.categories,
          widget.userData["week_start"],
        ) ??
        [];

    return grid.firstWhere((dayData) {
      final DateTime d = dayData["date"];
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }, orElse: () => {"date": date, "events": []});
  }

  List<Map>? _getGridList() {
    if (_mode == CalendarViewMode.month) {
      return gridBuildUseCase.execute(
        "build_month_grid",
        _referenceDate,
        widget.events,
        widget.categories,
        widget.userData["week_start"],
      );
    } else if (_mode == CalendarViewMode.week) {
      return gridBuildUseCase.execute(
        "build_week_grid",
        _referenceDate,
        widget.events,
        widget.categories,
        widget.userData["week_start"],
      );
    } else if (_mode == CalendarViewMode.day) {
      return gridBuildUseCase.execute(
        "build_day_grid",
        _selectedDate,
        widget.events,
        widget.categories,
        widget.userData["week_start"],
      );
    }

    return null;
  }

  String capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }

  void _onModeSelected(CalendarViewMode mode) {
    if (mode == _mode) {
      return;
    }
    setState(() {
      _mode = mode;
    });
  }

  (List<Map>, List<String>) _prepareWeekdayData(List<Map> gridList) {
    final List<String> hoursScale = [
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
      "13",
      "14",
      "15",
      "16",
      "17",
      "18",
      "19",
      "20",
      "21",
      "22",
      "23",
    ];
    List<Map> weekdaysList = [];

    for (Map dateData in gridList) {
      final day = dateData["date"].day;
      final weekday = getWeekdayNameUseCase.execute(
        weekday: dateData["date"].weekday,
        form: WeekdayNameForm.short,
      );

      final now = DateTime.now();

      weekdaysList.add({
        "text": "$weekday, $day",
        "is_selected":
            dateData["date"].year == _selectedDate.year &&
            dateData["date"].month == _selectedDate.month &&
            dateData["date"].day == _selectedDate.day,
        "is_current_day":
            dateData["date"].year == now.year &&
            dateData["date"].month == now.month &&
            dateData["date"].day == now.day,
      });
    }

    return (weekdaysList, hoursScale);
  }

  Widget _buildCalendarView() {
    // Calendar view
    List<Map>? gridList = _getGridList();

    if (gridList == null) {
      return Text("Nothing has found");
    }

    if (_mode == CalendarViewMode.month) {
      return _buildMonthCalendar(gridList);
    } else if (_mode == CalendarViewMode.week) {
      final (weekDays, hoursScale) = _prepareWeekdayData(gridList);

      const double timeColumnWidth = 17;
      const double dayWidth = 40;
      const double hourHeight = 40;

      return _buildWeekCalendar(
        gridList,
        weekDays,
        hoursScale,
        timeColumnWidth,
        dayWidth,
        hourHeight,
      );
    } else if (_mode == CalendarViewMode.day) {
      return _buildDayCalendar(gridList);
    } else {
      return Text("Nothing has found");
    }
  }

  Widget _buildMonthCalendar(List<Map> gridList) {
    return Column(
      children: [
        _buildWeekDaysRow(),
        const SizedBox(height: 8),
        Container(
          height: 270,
          color: Colors.transparent,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: gridList.length,
            itemBuilder: (context, index) {
              Map dateData = gridList[index];
              return CalendarDayCell(
                dateData: dateData,
                selectedDate: _selectedDate,
                onTap: () {
                  setState(() {
                    _selectedDate = dateData["date"];
                    setCurrentDateData(dateData);
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeekCalendar(
    List<Map> gridList,
    List<Map> weekDays,
    List<String> hoursScale,
    double timeColumnWidth,
    double dayWidth,
    double hourHeight,
  ) {
    return SizedBox(
      height: 330,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Row(
                children: weekDays.map((dayData) {
                  return SizedBox(
                    width: dayWidth,
                    height: 30,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: dayData["is_selected"]
                            ? const Color(0xFFFDEFE6)
                            : Colors.transparent,
                        border: Border.all(
                          color: dayData["is_current_day"]
                              ? const Color(0xFFFD8346)
                              : Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        dayData["text"],
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: timeColumnWidth,
                      child: Column(
                        children: hoursScale.map((hour) {
                          return SizedBox(
                            width: timeColumnWidth,
                            height: hourHeight,
                            child: Center(
                              child: Text(hour, style: TextStyle(fontSize: 12)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: List.generate(7, (dayIndex) {
                          return SizedBox(
                            width: dayWidth,
                            child: Column(
                              children: List.generate(24, (hourIndex) {
                                final DateTime day = gridList[dayIndex]["date"];

                                return CalendarHourCell(
                                  hourStart: DateTime(
                                    day.year,
                                    day.month,
                                    day.day,
                                    hourIndex,
                                  ),
                                  events: gridList[dayIndex]["events"],
                                  onTap: () {
                                    setState(() {
                                      _selectedDate =
                                          gridList[dayIndex]["date"];
                                      setCurrentDateData(gridList[dayIndex]);
                                    });
                                  },
                                );
                              }),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCalendar(List<Map> gridList) {
    const double rowHeight = 45;

    return SizedBox(
      height: 270,
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: Column(
                children: List.generate(gridList.length, (index) {
                  final DateTime date = gridList[index]["date"];
                  return SizedBox(
                    height: rowHeight,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "${date.hour.toString().padLeft(2, "0")}:00",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              width: 250,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: List.generate(gridList.length, (index) {
                    final List events = gridList[index]["events"] ?? const [];

                    return Container(
                      height: rowHeight,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(31, 81, 81, 81),
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        // Если «пилюли» не помещаются по ширине - ряд скроллится
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // ...[] - распакова коллекции с виджетами,
                              // который нужно добавлять каждую итерацию цикла
                              for (int i = 0; i < events.length; i++) ...[
                                if (i > 0) const SizedBox(width: 6),
                                EventPill(event: events[i] as Map),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FB), // tema
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TopBar(),
              const SizedBox(height: 16),
              ModeSwitcher(mode: _mode, onModeSelected: _onModeSelected),
              const SizedBox(height: 16),
              _buildCalendarContainer(),
              const SizedBox(height: 20),
              EventsContainer(
                currentDateText: currentDateText,
                currentWeekday: currentWeekday,
                currentDayEventsCount: currentDayEventsCount,
                events: currentDayEvents,
                onEventTap: (event) async {
                  final deleted = await showEventDetailsModal(
                    context,
                    event: event,
                    onDelete: (event) async {
                      final session = await widget.storage.read(key: "session");

                      final result = await widget.calendarScreenEventUseCase
                          .sendEventDeleteRequest(event["id"], session);

                      if (result["success"] == true) {
                        widget.removeEvent?.call(event["id"]);
                      }

                      if (mounted) {
                        Navigator.pop(context, true);
                      }
                    },
                  );

                  if (deleted && mounted) {
                    setState(() {
                      setCurrentDateData(_dayDataFor(_selectedDate));
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekDaysRow() {
    return Row(
      children: List.generate(
        7,
        (index) => Expanded(
          child: Center(
            child: Text(
              getWeekdayNameUseCase.execute(
                weekday: index + 1,
                form: WeekdayNameForm.short,
                weekStart: widget.userData["week_start"],
              ),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black45,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setCurrentDateData(Map dateData) {
    String currentDateMonth = getMonthNameUseCase.execute(
      month: dateData["date"].month,
      form: MonthNameForm.genitive,
    );

    currentDateText = "${dateData["date"].day} $currentDateMonth";

    currentWeekday = getWeekdayNameUseCase.execute(
      weekday: dateData['date'].weekday,
      form: WeekdayNameForm.full,
      weekStart: widget.userData["week_start"],
    );

    currentDayEvents = List<Map>.from(dateData['events'] ?? const []);
    currentDayEventsCount = currentDayEvents.length.toString();
  }

  Widget _buildCalendarContainer() {
    late String monthText;

    if (_mode == CalendarViewMode.day) {
      monthText = getMonthNameUseCase.execute(
        month: _referenceDate.month,
        form: MonthNameForm.genitive,
      );
    } else {
      monthText = currentMonthText;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CalendarNavHeader(
            referenceDate: _referenceDate,
            selectedDate: _selectedDate,
            currentMonthText: monthText,
            mode: _mode,
            isDayView: _mode == CalendarViewMode.day ? true : false,
            onPreviousMonth: () {
              setState(() {
                _referenceDate = DateTime(
                  _referenceDate.year,
                  _referenceDate.month - 1,
                  1,
                );

                currentMonthText = capitalize(
                  getMonthNameUseCase.execute(
                    month: _referenceDate.month,
                    form: MonthNameForm.nominative,
                  ),
                );
              });
            },
            onNextMonth: () {
              setState(() {
                _referenceDate = DateTime(
                  _referenceDate.year,
                  _referenceDate.month + 1,
                  1,
                );

                currentMonthText = capitalize(
                  getMonthNameUseCase.execute(
                    month: _referenceDate.month,
                    form: MonthNameForm.nominative,
                  ),
                );
              });
            },
            onNextWeek: () {
              setState(() {
                _referenceDate = DateTime(
                  _referenceDate.year,
                  _referenceDate.month,
                  _referenceDate.day + 7,
                );

                currentMonthText = capitalize(
                  getMonthNameUseCase.execute(
                    month: _referenceDate.month,
                    form: MonthNameForm.nominative,
                  ),
                );
              });
            },
            onPreviousWeek: () {
              setState(() {
                _referenceDate = DateTime(
                  _referenceDate.year,
                  _referenceDate.month,
                  _referenceDate.day - 7,
                );

                currentMonthText = capitalize(
                  getMonthNameUseCase.execute(
                    month: _referenceDate.month,
                    form: MonthNameForm.nominative,
                  ),
                );
              });
            },
            onToday: () {
              setState(() {
                _referenceDate = DateTime.now();
                _selectedDate = DateTime.now();

                currentMonthText = capitalize(
                  getMonthNameUseCase.execute(
                    month: _referenceDate.month,
                    form: MonthNameForm.nominative,
                  ),
                );

                setCurrentDateData(_dayDataFor(_selectedDate));
              });
            },
          ),
          const SizedBox(height: 16),
          _buildCalendarView(),
        ],
      ),
    );
  }
}
