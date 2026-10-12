import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/switch_widget.dart';

class ProfileSettingItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback? onTap;

  final bool showSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  const ProfileSettingItem({
    super.key,
    required this.title,
    required this.iconPath,
    this.onTap,
    this.showSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showSwitch ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF111936),
                ),
              ),
            ),

            if (showSwitch)
              ProfileSwitch(
                value: switchValue,
                onChanged: onSwitchChanged,
              )
            else
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
