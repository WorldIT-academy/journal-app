import 'package:flutter/material.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/event_modal/event_text_field.dart';

Future<void> showSettingsModal(
  BuildContext context, {
  required Future<void> Function(Map<String, String> data) onSave,
  VoidCallback? onChangeAvatar,
  VoidCallback? onDeleteAvatar,
  ImageProvider? avatar,
  String firstName = "",
  String lastName = "",
  String workDayStart = "",
  String workDayEnd = "",
  int weekStart = DateTime.monday,
}) {
  return showDialog(
    context: context,
    builder: (_) => SettingsModal(
      onSave: onSave,
      onChangeAvatar: onChangeAvatar,
      onDeleteAvatar: onDeleteAvatar,
      avatar: avatar,
      firstName: firstName,
      lastName: lastName,
      workDayStart: workDayStart,
      workDayEnd: workDayEnd,
      weekStart: weekStart,
    ),
  );
}

class SettingsModal extends StatefulWidget {
  final Future<void> Function(Map<String, String> data) onSave;
  final VoidCallback? onChangeAvatar;
  final VoidCallback? onDeleteAvatar;

  // Начальные значения полей
  final ImageProvider? avatar;
  final String firstName;
  final String lastName;
  final String workDayStart;
  final String workDayEnd;
  final int weekStart;

  const SettingsModal({
    required this.onSave,
    this.onChangeAvatar,
    this.onDeleteAvatar,
    this.avatar,
    this.firstName = "",
    this.lastName = "",
    this.workDayStart = "",
    this.workDayEnd = "",
    this.weekStart = DateTime.monday,
    super.key,
  });

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  static const Color _accent = Color(0xFF8E8BBE);
  static const Color _secondaryColor = Color(0xFF6E7191);
  static const Color _avatarBackground = Color(0xFFE4E3EE);
  static const Color _deleteColor = Color(0xFFE5484D);

  // Варианты начала недели: значение - номер дня в DateTime
  static const Map<int, String> _weekStartOptions = {
    DateTime.monday: "Понеділок",
    DateTime.sunday: "Неділя",
  };

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _workDayStartController;
  late final TextEditingController _workDayEndController;
  late int _weekStart;

  bool _isSaving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
    _workDayStartController = TextEditingController(text: widget.workDayStart);
    _workDayEndController = TextEditingController(text: widget.workDayEnd);
    _weekStart = widget.weekStart;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _workDayStartController.dispose();
    _workDayEndController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    final data = {
      "first_name": _firstNameController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      "work_day_start": _workDayStartController.text.trim(),
      "work_day_end": _workDayEndController.text.trim(),
      "week_start": _weekStart.toString(),
    };

    try {
      await widget.onSave(data);
    } catch (_) {
      if (mounted) {
        setState(() => _errorText = "Не вдалося зберегти налаштування");
      }
    }

    // Если onSave закрыл модалку, она уже не в дереве (mounted == false)
    if (mounted) {
      setState(() => _isSaving = false);
    }
  }

  Widget _buildAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: _avatarBackground,
        shape: BoxShape.circle,
        image: widget.avatar == null
            ? null
            : DecorationImage(image: widget.avatar!, fit: BoxFit.cover),
      ),
      child: widget.avatar == null
          ? const Icon(Icons.person_outline_rounded, size: 40, color: _accent)
          : null,
    );
  }

  // Квадратная кнопка с иконкой (смена и удаление фото)
  Widget _buildSquareButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 49,
      height: 49,
      child: ElevatedButton(
        onPressed: _isSaving ? null : onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: _accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Зображення профілю",
          style: TextStyle(fontSize: 12, color: _secondaryColor),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildAvatar(),
            const Spacer(),
            _buildSquareButton(
              icon: Icons.sync_rounded,
              onTap: widget.onChangeAvatar,
            ),
            const SizedBox(width: 12),
            _buildSquareButton(
              icon: Icons.delete_outline_rounded,
              onTap: widget.onDeleteAvatar,
            ),
          ],
        ),
      ],
    );
  }

  // Выпадающий список начала недели в стиле полей формы
  Widget _buildWeekStartField() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE4E3EC)),
    );

    return DropdownButtonFormField<int>(
      initialValue: _weekStart,
      onChanged: _isSaving
          ? null
          : (value) => setState(() => _weekStart = value ?? _weekStart),
      items: _weekStartOptions.entries
          .map(
            (entry) =>
                DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          )
          .toList(),
      borderRadius: BorderRadius.circular(12),
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        labelText: "Початок тижня",
        labelStyle: const TextStyle(color: _secondaryColor),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: _accent, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = (screenHeight - 150).clamp(200.0, double.infinity);

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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Налаштування",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildAvatarSection(),
                          const SizedBox(height: 24),
                          EventTextField(
                            label: "Ім'я",
                            controller: _firstNameController,
                          ),
                          const SizedBox(height: 16),
                          EventTextField(
                            label: "Прізвище",
                            controller: _lastNameController,
                          ),
                          const SizedBox(height: 16),
                          EventTextField(
                            label: "Початок робочого дня",
                            controller: _workDayStartController,
                            isTime: true,
                          ),
                          const SizedBox(height: 16),
                          EventTextField(
                            label: "Кінець робочого дня",
                            controller: _workDayEndController,
                            isTime: true,
                          ),
                          const SizedBox(height: 16),
                          _buildWeekStartField(),
                          if (_errorText != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _errorText!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: _deleteColor,
                              ),
                            ),
                          ],
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Кнопки скасувати и зберегти (закреплены внизу)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () => Navigator.pop(context),
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
                      child: const Text("Скасувати"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _submit,
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
                      child: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Зберегти"),
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
