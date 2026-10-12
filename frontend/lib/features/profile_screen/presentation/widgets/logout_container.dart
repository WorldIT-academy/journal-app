import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ProfileLogoutButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFFF3030),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/settings_icons/light/log-out.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 14),
            const Text(
              'Вийти',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF3030),
              ),
            ),
          ],
        ),
      ),
    );
  }
}