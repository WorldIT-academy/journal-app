import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:journal_app/features/profile_screen/domain/use_cases/profile_category_use_case.dart';
import 'package:journal_app/features/profile_screen/domain/use_cases/user_data_use_case.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/logout_container.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/category_item_modal/category_item_modal.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/profile_categories_container.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/profile_category_item.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/profile_setting_item.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/profile_settings_container.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/profile_user_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onPressed;

  final ProfileCategoryUseCase profileCategoryUseCase;

  final FlutterSecureStorage storage;

  // Categories
  final List<Map> categories;
  final void Function(int id)? removeCategory;

  // User data
  final UserDataUseCase userDataUseCase;
  final Map userData;
  final void Function(Map data)? writeUserData;

  const ProfileScreen({
    required this.onPressed,
    required this.profileCategoryUseCase,
    required this.userDataUseCase,
    required this.storage,
    required this.categories,
    required this.removeCategory,
    required this.userData,
    required this.writeUserData,
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkThemeEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }

  @override
  Widget build(BuildContext context) {
    List<ProfileCategoryItem> _categoriesWidgets = [];

    for (Map category in widget.categories) {
      _categoriesWidgets.add(
        ProfileCategoryItem(
          title: category["name"],
          count: 0,
          color: hexToColor(category["color"]),
          iconPath: "assets/categories_icons/light/${category["icon"]}",
          onTap: () => showDialog(
            context: context,
            builder: (context) {
              return CategoryItemModal(
                title: category["name"],
                color: hexToColor(category["color"]),
                iconPath: "assets/categories_icons/light/${category["icon"]}",
                onDelete: () async {
                  final session = await widget.storage.read(key: "session");

                  final result = await widget.profileCategoryUseCase
                      .sendDeleteCategoryRequest(category["id"], session);

                  if (result["success"] == true) {
                    widget.removeCategory?.call(category["id"]);
                  }

                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                },
              );
            },
          ),
        ),
      );
    }


    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Профіль',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111936),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/settings_icons/light/settings.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // User information
              ProfileUserCard(
                userData: widget.userData,
                userDataUseCase: widget.userDataUseCase,
                storage: widget.storage,
                writeUserData: widget.writeUserData
              ),

              const SizedBox(height: 28),

              // Categories
              const Text(
                'Мої категорії',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111936),
                ),
              ),

              const SizedBox(height: 12),

              ProfileCategoriesContainer(categories: _categoriesWidgets),

              const SizedBox(height: 28),

              // Settings
              const Text(
                'Налаштування',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111936),
                ),
              ),

              const SizedBox(height: 12),

              ProfileSettingsContainer(
                children: [
                  ProfileSettingItem(
                    title: 'Сповіщення',
                    iconPath: 'assets/settings_icons/light/bell.svg',
                    onTap: () {},
                  ),
                  ProfileSettingItem(
                    title: 'Синхронізація календаря',
                    iconPath: 'assets/settings_icons/light/refresh-cw.svg',
                    onTap: () {},
                  ),
                  ProfileSettingItem(
                    title: 'Мова',
                    iconPath: 'assets/settings_icons/light/languages.svg',
                    onTap: () {},
                  ),
                  ProfileSettingItem(
                    title: 'Темна тема',
                    iconPath: 'assets/settings_icons/light/sun.svg',
                    showSwitch: true,
                    switchValue: _darkThemeEnabled,
                    onSwitchChanged: (value) {
                      setState(() {
                        _darkThemeEnabled = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Logout
              ProfileLogoutButton(onPressed: widget.onPressed),
            ],
          ),
        ),
      ),
    );
  }
}
