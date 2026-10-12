import 'package:flutter/material.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/month_name_form.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/weekday_name.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_color.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_time.dart';

// Открытие модального окна с информацией по событию
Future<bool> showEventDetailsModal(
  BuildContext context, {
  required Map event,
  required Future<void> Function(Map event) onDelete,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => EventDetailsModal(event: event, onDelete: onDelete),
  );

  return result ?? false;
}

// Открытие модального окна подтверждения удаления события
Future<bool> showDeleteEventDialog(BuildContext context, String title) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              "Видалити подію?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "«$title» буде видалено без можливості відновлення",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6E7191)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    style: _outlinedStyle(Color(0xFF8E8BBE)),
                    child: const Text("Скасувати"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogContext, true),
                    style: _filledStyle(Color(0xFFE5484D)),
                    child: const Text("Видалити"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  return result ?? false;
}

ButtonStyle _outlinedStyle(Color color) {
  return OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(48),
    foregroundColor: color,
    side: BorderSide(color: color, width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  );
}

ButtonStyle _filledStyle(Color color) {
  return ElevatedButton.styleFrom(
    minimumSize: const Size.fromHeight(48),
    backgroundColor: color,
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  );
}

// Модалка с информацией по событию
class EventDetailsModal extends StatefulWidget {
  final Map event;
  final Future<void> Function(Map event) onDelete;

  const EventDetailsModal({
    required this.event,
    required this.onDelete,
    super.key,
  });

  @override
  State<EventDetailsModal> createState() => _EventDetailsModalState();
}

class _EventDetailsModalState extends State<EventDetailsModal> {
  final ScrollController _scrollController = ScrollController();

  final GetMonthName _getMonthName = GetMonthName();
  final GetWeekdayName _getWeekdayName = GetWeekdayName();

  bool _isDeleting = false;

  // лень прописывать widget.event каждый раз
  // так короче
  Map get _event => widget.event;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String? _nonEmpty(dynamic value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  // Сборка даты для отображения
  // Например "32 января 2020, середа"
  String _formatDate(DateTime? date) {
    if (date == null) {
      return "—";
    }

    final month = _getMonthName.execute(
      month: date.month,
      form: MonthNameForm.genitive,
    );
    final weekday = _getWeekdayName.execute(
      weekday: date.weekday,
      form: WeekdayNameForm.full,
    );

    return "${date.day} $month ${date.year}, $weekday";
  }

  Future<void> _onDeletePressed() async {
    final title = _nonEmpty(_event["title"]) ?? "Подія";

    final confirmed = await showDeleteEventDialog(context, title);
    if (!confirmed || !mounted) {
      return;
    }

    setState(() => _isDeleting = true);

    try {
      await widget.onDelete(_event);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _isDeleting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Не вдалося видалити подію")),
      );
    }
  }

  // сборка контейнера в цвет категории
  Widget _buildCategoryPill() {
    final name = _nonEmpty(_event["name"]);
    if (name == null) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: parseEventColor(_event["color"]).withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // Информационный блок для отображения данных события
  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6E7191)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF14142B),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return TextButton.icon(
      onPressed: _isDeleting ? null : _onDeletePressed,
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFFE5484D),
        minimumSize: const Size.fromHeight(48),
        backgroundColor: Color(0xFFE5484D).withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      icon: _isDeleting
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFE5484D),
              ),
            )
          : const Icon(Icons.delete_outline_rounded),
      label: const Text("Видалити"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = (screenHeight - 150).clamp(200.0, double.infinity);

    final title = _nonEmpty(_event["title"]) ?? "Без назви";
    final description = _nonEmpty(_event["description"]);
    final location = _nonEmpty(_event["location"]);

    final start = parseEventTime(_event["start_at"]);
    final end = parseEventTime(_event["end_at"]);

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
              // Прокручиваемая часть
              Flexible(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCategoryPill(),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (description != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6E7191),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        _buildField("Дата", _formatDate(start)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildField(
                                "Початок",
                                formatHourMinute(start),
                              ),
                            ),
                            Expanded(
                              child: _buildField(
                                "Кінець",
                                formatHourMinute(end),
                              ),
                            ),
                          ],
                        ),
                        if (location != null) ...[
                          const SizedBox(height: 16),
                          _buildField("Локація", location),
                        ],
                        const SizedBox(height: 24),
                        _buildDeleteButton(),
                        const SizedBox(height: 8),
                      ],
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
                      onPressed: _isDeleting
                          ? null
                          : () => Navigator.pop(context, false),
                      style: _outlinedStyle(Color(0xFF8E8BBE)),
                      child: const Text("Скасувати"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isDeleting
                          ? null
                          : () => Navigator.pop(context, false),
                      style: _filledStyle(Color(0xFF8E8BBE)),
                      child: const Text("Готово"),
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
