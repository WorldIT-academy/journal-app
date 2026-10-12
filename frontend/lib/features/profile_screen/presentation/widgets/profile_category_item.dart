import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileCategoryItem extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final String iconPath;
  final VoidCallback? onTap;

  const ProfileCategoryItem({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 18,
                  height: 22,
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111936),
                ),
              ),
            ),

            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF7C83A6),
              ),
            ),

            const SizedBox(width: 12),

            SvgPicture.asset(
              "assets/action_icons/light/chevron-right.svg",
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
