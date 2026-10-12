import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CircleIconButton extends StatelessWidget {

  final VoidCallback onTap;
  final String path;
  final bool showBadge;

  const CircleIconButton({
    super.key,
    required this.onTap,
    required this.path,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.white, // Tтема
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SizedBox(width: 20, height: 20, child: SvgPicture.asset(path))
          ),
          if (showBadge)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF8A3D), // Tтема
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
