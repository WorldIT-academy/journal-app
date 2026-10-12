import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 70,
          backgroundColor: const Color(0xFFFFFEFE),
          indicatorColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(
            Colors.transparent,
          ),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                  color: Color(0xFFFF6B00),
                );
              }

              return const TextStyle(
                color: Colors.black,
              );
            },
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: [
            NavigationDestination(
              icon: SizedBox(
                width: 26,
                height: 26,
                child: SvgPicture.asset(
                  currentIndex == 0
                      ? 'assets/navigation_bar/orange/today.svg'
                      : 'assets/navigation_bar/light/today.svg',
                ),
              ),
              label: 'Сьогодні',
            ),
            NavigationDestination(
              icon: SizedBox(
                width: 26,
                height: 26,
                child: SvgPicture.asset(
                  currentIndex == 1
                      ? 'assets/navigation_bar/orange/calendar.svg'
                      : 'assets/navigation_bar/light/calendar.svg',
                ),
              ),
              label: 'Календар',
            ),
            NavigationDestination(
              icon: SizedBox(
                width: 26,
                height: 26,
                child: SvgPicture.asset(
                  currentIndex == 2
                      ? 'assets/navigation_bar/orange/profile.svg'
                      : 'assets/navigation_bar/light/profile.svg',
                ),
              ),
              label: 'Профіль',
            ),
          ],
        ),
      ),
    );
  }
}