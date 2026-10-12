import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/event_modal/field_border.dart';

class EventTextField extends StatelessWidget {
  static const Color _accent = Color(0xFF8E8BBE);
  static const Color _border = Color(0xFFE0DEEA);

  final String label;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;
  final bool isTime;
  final String? errorText;

  const EventTextField({
    required this.label,
    required this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.isTime = false,
    this.errorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: isTime ? TextInputType.number : TextInputType.text,
      inputFormatters: isTime
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
              TimeInputFormatter(),
            ]
          : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Обов'язкове поле";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _accent),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorText: errorText,
        border: fieldBorder(_border),
        enabledBorder: fieldBorder(_border),
        focusedBorder: fieldBorder(_accent),
        errorBorder: fieldBorder(Colors.red.shade400),
        focusedErrorBorder: fieldBorder(Colors.red.shade400),
      ),
    );
  }
}

// Кастомный форматтер для полей ввода,
// предназначенных для введения времени
class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 4) {
      return oldValue;
    }

    if (digits.length >= 2) {
      final hours = int.tryParse(digits.substring(0, 2));

      if (hours != null && hours > 23) {
        return oldValue;
      }
    }

    if (digits.length == 4) {
      final minutes = int.tryParse(digits.substring(2, 4));

      if (minutes != null && minutes > 59) {
        return oldValue;
      }
    }

    final formatted = digits.length > 2
        ? '${digits.substring(0, 2)}:${digits.substring(2)}'
        : digits;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}