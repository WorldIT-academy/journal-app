import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Заголовок секции: слева название, справа необязательный текст
// (например, «Через 18 хв» или ссылка «Всі події ›»)
class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailingText;
  final bool showChevron;
  final VoidCallback? onTrailingTap;

  static const String chevronPath =
      'assets/action_icons/light/chevron-right.svg';
  static const Color _secondaryColor = Color(0xFF6E7191);

  const SectionHeader({
    required this.title,
    this.trailingText,
    this.showChevron = false,
    this.onTrailingTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111936),
          ),
        ),
        if (trailingText != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTrailingTap,
            child: Row(
              children: [
                Text(
                  trailingText!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _secondaryColor,
                  ),
                ),
                if (showChevron) ...[
                  const SizedBox(width: 2),
                  SvgPicture.asset(
                    chevronPath,
                    width: 14,
                    height: 14,
                    colorFilter: const ColorFilter.mode(
                      _secondaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}