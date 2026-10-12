import 'package:flutter/material.dart';
import 'package:journal_app/features/profile_screen/domain/use_cases/user_data_use_case.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/profile_statistic.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/profile_statistic_divider.dart';
import 'package:journal_app/features/profile_screen/presentation/widgets/user_settings_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileUserCard extends StatelessWidget {
  final UserDataUseCase userDataUseCase;
  final FlutterSecureStorage storage;

  // User data
  final Map userData;
  final void Function(Map data)? writeUserData;

  const ProfileUserCard({
    required this.userData,
    required this.userDataUseCase,
    required this.storage,
    required this.writeUserData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/base_user_icons/base_user_avatar.png',
                  width: 53,
                  height: 53,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${userData["first_name"] ?? "Не вказано"} ${userData["last_name"] ?? ""}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111936),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      userData["email"] ?? "Не вказано",
                      style: TextStyle(fontSize: 14, color: Color(0xFF7C83A6)),
                    ),
                  ],
                ),
              ),

              OutlinedButton(
                onPressed: () {
                  showSettingsModal(
                    context,
                    firstName: userData["first_name"] ?? "",
                    lastName: userData["last_name"] ?? "",
                    workDayStart:
                        userData["work_day_start"]?.toString().substring(
                          11,
                          16,
                        ) ??
                        "",
                    workDayEnd:
                        userData["work_day_end"]?.toString().substring(
                          11,
                          16,
                        ) ??
                        "",
                    weekStart: userData["week_start"] ?? DateTime.monday,
                    onChangeAvatar: () {},
                    onDeleteAvatar: () {},
                    onSave: (data) async {
                      final session = await storage.read(key: "session");

                      final result = await userDataUseCase
                          .sendUpdateUserDataRequest(data, session);

                      if (result["success"] != true) {
                        throw Exception("Settings save failed");
                      }

                      final newData = {
                        ...userData,
                        "first_name": data["first_name"],
                        "last_name": data["last_name"],
                        "work_day_start": "1900-01-01T${data["work_day_start"]}:00",
                        "work_day_end": "1900-01-01T${data["work_day_end"]}:00",
                        "week_start": int.parse(data["week_start"]!),
                      };

                      writeUserData?.call(newData);

                      Navigator.pop(context);
                    },
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF111936),
                  side: const BorderSide(color: Color(0xFFDDE0EC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                child: const Text('Редагувати', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(height: 1, color: const Color(0xFFE9EAF1)),

          const SizedBox(height: 16),

          const Row(
            children: [
              Expanded(
                child: ProfileUserStatistic(value: '0', label: 'подій'),
              ),
              SizedBox(width: 16),
              ProfileStatisticDivider(),
              SizedBox(width: 16),
              Expanded(
                child: ProfileUserStatistic(value: '0', label: 'завдання'),
              ),
              SizedBox(width: 16),
              ProfileStatisticDivider(),
              SizedBox(width: 16),
              Expanded(
                child: ProfileUserStatistic(value: '0%', label: 'виконано'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
