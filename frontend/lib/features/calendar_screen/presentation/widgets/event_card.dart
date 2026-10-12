import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_color.dart';
import 'package:journal_app/features/calendar_screen/presentation/widgets/event_time.dart';

// Карточка одного события в списке под календарём
class EventCard extends StatelessWidget {
  final Map event;
  final VoidCallback? onTap;

  static const int maxDescriptionLength = 25;
  static const String chevronPath =
      'assets/action_icons/light/chevron-right.svg';

  static const Color _titleColor = Color(0xFF14142B);
  static const Color _secondaryColor = Color(0xFF6E7191);
  static const Color _dividerColor = Color(0xFFEFEEF3);

  const EventCard({required this.event, this.onTap, super.key});

  // Обрезает строку до 25 символов и добавляет ...
  String _shorten(String text) {
    final trimmed = text.trim();
    if (trimmed.length <= maxDescriptionLength) {
      return trimmed;
    }
    return "${trimmed.substring(0, maxDescriptionLength).trimRight()}...";
  }

  String? _nonEmpty(dynamic value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  Widget _buildStripe(Color color) {
    return Container(
      width: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildTimes() {
    final start = parseEventTime(event["start_at"]);
    final end = parseEventTime(event["end_at"]);

    return SizedBox(
      width: 56,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatHourMinute(start),
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: _titleColor,
            ),
          ),
          const SizedBox(height: 4),
          if (end != null)
            Text(
              formatHourMinute(end),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: _secondaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _secondaryColor),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: _secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDetails(Color color) {
    final title = _nonEmpty(event["title"]) ?? "Без назви";
    final description = _nonEmpty(event["description"]);
    final location = _nonEmpty(event["location"]);
    final categoryName = _nonEmpty(event["name"]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _titleColor,
                ),
              ),
            ),
            if (categoryName != null) ...[
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: _buildCategoryPill(categoryName, color),
              ),
            ],
          ],
        ),
        if (description != null)
          _buildInfoRow(Icons.notes_rounded, _shorten(description)),
        if (location != null)
          _buildInfoRow(Icons.location_on_outlined, location),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = parseEventColor(event["color"]);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        // IntrinsicHeight нужен, чтобы полоска и разделитель
        // растягивались на всю высоту карточки
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStripe(color),
              const SizedBox(width: 12),
              _buildTimes(),
              const SizedBox(width: 8),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: _dividerColor,
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildDetails(color)),
              const SizedBox(width: 8),
              Center(
                child: SvgPicture.asset(
                  chevronPath,
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    _titleColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
