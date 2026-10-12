import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CategoryTile extends StatelessWidget {
  final String title;
  final Color color;
  final String iconPath;
  final int count;
  final VoidCallback? onTap;

  const CategoryTile({
    super.key,
    required this.title,
    required this.color,
    required this.iconPath,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 18,
                  height: 22,
                  // Если файл не найден, показываем запасную иконку
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.category, size: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111936),
                ),
              ),
            ),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 16, color: Color(0xFF7C83A6)),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
