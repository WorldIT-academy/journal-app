import 'package:flutter/material.dart';

class ProfileUserStatistic extends StatelessWidget {
  final String value;
  final String label;

  const ProfileUserStatistic({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111936),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF7C83A6),
          ),
        ),
      ],
    );
  }
}