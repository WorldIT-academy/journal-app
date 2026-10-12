import 'package:flutter/material.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/profile_setting_item.dart';

class ProfileSettingsContainer extends StatelessWidget {
  final List<ProfileSettingItem> children;

  const ProfileSettingsContainer({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 0),
                child: Divider(
                  height: 1,
                  color: Color(0xFFE9EAF1),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
