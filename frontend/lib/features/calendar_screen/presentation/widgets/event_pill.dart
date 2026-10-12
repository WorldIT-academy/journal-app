import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_color.dart';

// «пилюля» события в дневном представлении
class EventPill extends StatelessWidget {
  final Map event;

  static const double iconSize = 29;
  static const double height = 37;
  static const double maxWidth = 200;
  static const String iconsPath = 'assets/categories_icons/light/';

  const EventPill({required this.event, super.key});

  Widget _buildIcon() {
    final String? name = event["icon"] as String?;

    if (name == null || name.isEmpty) {
      return const SizedBox(width: iconSize, height: iconSize);
    }

    final String fileName = name;
    final String path = '$iconsPath$fileName';

    if (fileName.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: iconSize,
        height: iconSize,
        placeholderBuilder: (_) =>
            const SizedBox(width: iconSize, height: iconSize),
      );
    }

    return Image.asset(
      path,
      width: iconSize,
      height: iconSize,
      errorBuilder: (_, _, _) =>
          const SizedBox(width: iconSize, height: iconSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: parseEventColor(event["color"]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                (event["title"] ?? "") as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
