import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Color(0xFF8E8BBE)),
    );
  }
}
