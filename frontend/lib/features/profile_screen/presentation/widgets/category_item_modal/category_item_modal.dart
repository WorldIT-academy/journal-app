import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryItemModal extends StatefulWidget {
  final String title;
  final Color color;
  final String iconPath;
  final VoidCallback? onDelete;

  const CategoryItemModal({
    required this.title,
    required this.color,
    required this.iconPath,
    required this.onDelete,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CategoryItemModalState();
}

class _CategoryItemModalState extends State<CategoryItemModal> {
  static const Color _accent = Color(0xFF8E8BBE);

  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Категорія',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 24),

            SvgPicture.asset(widget.iconPath, width: 56, height: 56),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              height: 10,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111936),
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
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
                    child: const Text('Скасувати'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onDelete,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: Colors.red,
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
                    child: const Text('Видалити'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
