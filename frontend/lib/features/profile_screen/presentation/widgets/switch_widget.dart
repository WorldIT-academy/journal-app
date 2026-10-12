import 'package:flutter/material.dart';

class ProfileSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const ProfileSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged?.call(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 54,
        height: 26,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value
              ? const Color(0xFFFF6B00)
              : const Color(0xFFDDE0E8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
