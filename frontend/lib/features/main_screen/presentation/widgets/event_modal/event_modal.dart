import 'package:flutter/material.dart';
import 'package:journal_app/features/main_screen/domain/use_cases/event_use_case.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/event_modal/calendar_header.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/event_modal/category_dropdown.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/event_modal/event_text_field.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/event_modal/month_calendar.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/event_modal/week_days_row.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EventModal extends StatefulWidget {
  final List<Map> categories;
  final List<Map> events;
  final FlutterSecureStorage storage;
  

  final MainScreenEventUseCase mainScreenEventUseCase;

  final void Function(Map event)? addEvent;

  // User data
  final Map userData;
  
  const EventModal({
    required this.categories,
    required this.events,
    required this.mainScreenEventUseCase,
    required this.storage,
    required this.addEvent,
    required this.userData,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _EventModalState();
}

class _EventModalState extends State<EventModal> {
  static const Color _accent = Color(0xFF8E8BBE);

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  Map? _selectedCategory;

  // Поля с текстами ошибок сервера
  // Добавлена возможность вывода ошибок сервера
  // на случай отключения клиентской валидации
  String? _startAtError;
  String? _endAtError;
  String? _titleError;
  String? _descriptionError;
  String? _locationError;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _displayedMonth = DateTime(now.year, now.month, 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _startController.dispose();
    _endController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + delta,
        1,
      );
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _selectedDate = DateTime(now.year, now.month, now.day);
      _displayedMonth = DateTime(now.year, now.month, 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      _displayedMonth = DateTime(date.year, date.month, 1);
    });
  }

  void _submit() async {
    // Валидация всех полей формы
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Map<String, dynamic> eventData = {
      // преобразуем date в строку формата YYYY-MM-DD
      // чтобы на сервере можно было её преобразовать в datetime объект,
      // уже в языке Python
      "date": _selectedDate.toIso8601String().split("T").first,
      "start": _startController.text.trim(),
      "end": _endController.text.trim(),
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "location": _locationController.text.trim(),
      "category_id": _selectedCategory != null
          ? _selectedCategory!["id"].toString()
          : "",
    };

    final session = await widget.storage.read(key: "session");

    final result = await widget.mainScreenEventUseCase.sendCreateCategoryRequest(
      eventData,
      session,
    );

    _startAtError = null;
    _endAtError = null;
    _titleError = null;
    _descriptionError = null;
    _locationError = null;
    _categoryError = null;

    if (result["success"] == true) {
      final eventData = {
        "id": result["data"]["id"],
        "start_at": result["data"]["start_at"],
        "end_at": result["data"]["end_at"],
        "title": result["data"]["title"],
        "description": result["data"]["description"],
        "location": result["data"]["location"],
        "category_id": result["data"]["category_id"],
      };

      // добавляем в общий список событий
      widget.addEvent?.call(eventData);

      // если вкладка уже закрыта, то state не в дереве виджетов
      // а значит закрывать модалку (через Navigator.pop()) не будем,
      // во избежание ошибок
      if (mounted) {
        Navigator.pop(context, eventData);
      }
    } else if (result["data"].keys.contains("error") &&
        result["data"].keys.contains("field")) {
      if (result["data"]["field"] == "calendar") {
        setState(() {
          _startAtError = result["data"]["error"];
          _endAtError = result["data"]["error"];
        });
      } else if (result["data"]["field"] == "start_at") {
        setState(() {
          _startAtError = result["data"]["error"];
        });
      } else if (result["data"]["field"] == "end_at") {
        setState(() {
          _endAtError = result["data"]["error"];
        });
      } else if (result["data"]["field"] == "title") {
        setState(() {
          _titleError = result["data"]["error"];
        });
      } else if (result["data"]["field"] == "description") {
        setState(() {
          _descriptionError = result["data"]["error"];
        });
      } else if (result["data"]["field"] == "location") {
        setState(() {
          _locationError = result["data"]["error"];
        });
      } else if (result["data"]["field"] == "category_id") {
        setState(() {
          _categoryError = result["data"]["error"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = (screenHeight - 150).clamp(200.0, double.infinity);
    final gridList = widget.mainScreenEventUseCase.buildMonthGrid(
      _displayedMonth,
      widget.userData["week_start"]
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Скроллируемая часть
              Flexible(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(right: 8),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Створіть подію',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          CalendarHeader(
                            month: _displayedMonth,
                            onPrev: () => _changeMonth(-1),
                            onNext: () => _changeMonth(1),
                            onToday: _goToToday,
                          ),
                          const SizedBox(height: 12),
                          WeekDaysRow(widget.userData["week_start"]),
                          const SizedBox(height: 4),
                          MonthCalendar(
                            gridList: gridList,
                            selectedDate: _selectedDate,
                            onDateSelected: _selectDate,
                          ),
                          const SizedBox(height: 24),
                          EventTextField(
                            label: 'Початок',
                            controller: _startController,
                            isTime: true,
                            errorText: _startAtError,
                          ),
                          const SizedBox(height: 16),
                          EventTextField(
                            label: 'Кінець',
                            controller: _endController,
                            isTime: true,
                            errorText: _endAtError,
                          ),
                          const SizedBox(height: 16),
                          EventTextField(
                            label: 'Назва',
                            controller: _titleController,
                            errorText: _titleError,
                          ),
                          const SizedBox(height: 16),
                          EventTextField(
                            label: 'Опис',
                            controller: _descriptionController,
                            minLines: 3,
                            maxLines: 5,
                            errorText: _descriptionError,
                          ),
                          const SizedBox(height: 16),
                          EventTextField(
                            label: 'Локація',
                            controller: _locationController,
                            errorText: _locationError,
                          ),
                          const SizedBox(height: 16),
                          CategoryDropdown(
                            categories: widget.categories,
                            value: _selectedCategory,
                            errorText: _categoryError,
                            onChanged: (c) =>
                                setState(() => _selectedCategory = c),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Кнопки (закреплены внизу)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        foregroundColor: _accent,
                        side: const BorderSide(color: _accent, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Скасувати'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: _accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Готово'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
