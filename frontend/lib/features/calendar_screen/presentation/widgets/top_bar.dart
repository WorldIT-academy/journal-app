import 'package:flutter/material.dart';
import 'circle_icon_button.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Календар',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            CircleIconButton(
              onTap: () {},
              path: 'assets/action_icons/light/search.svg',
            ),
            const SizedBox(width: 8),
            CircleIconButton(
              onTap: () {},
              path: 'assets/action_icons/light/bell.svg',
              showBadge: false,
            ),
          ],
        ),
      ],
    );
  }
}