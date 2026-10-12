import 'package:flutter/material.dart';
import 'package:journal_app/core/widgets/navigation_bar.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/event_use_case.dart';
import 'package:journal_app/features/calendar_screen/presentation/screen.dart';
import 'package:journal_app/features/main_screen/domain/use_cases/category_use_case.dart';
import 'package:journal_app/features/main_screen/domain/use_cases/event_use_case.dart';
import 'package:journal_app/features/profile_screen/domain/use_cases/profile_category_use_case.dart';
import 'package:journal_app/features/profile_screen/domain/use_cases/user_data_use_case.dart';
import 'package:journal_app/features/profile_screen/presentation/screen.dart';
import 'package:journal_app/features/today_screen/presentation/screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onPressed;

  final FlutterSecureStorage storage;

  // Categories
  final void Function(int id)? removeCategory;

  // Events
  final void Function(int id)? removeEvent;

  // User data
  final Map userData;
  final void Function(Map data)? writeUserData;

  final List<Map> categories;
  final List<Map> events;

  // Main screen use cases
  final CategoryUseCase categoryUseCase;
  final MainScreenEventUseCase mainScreenEventUseCase;
  final CalendarScreenEventUseCase calendarScreenEventUseCase;

  // Profile screen use cases
  final ProfileCategoryUseCase profileCategoryUseCase;
  final UserDataUseCase userDataUseCase;

  const MainScreen({
    required this.onPressed,
    required this.profileCategoryUseCase,
    required this.categoryUseCase,
    required this.mainScreenEventUseCase,
    required this.calendarScreenEventUseCase,
    required this.userDataUseCase,
    required this.storage,
    required this.categories,
    required this.removeCategory,
    required this.removeEvent,
    required this.events,
    required this.writeUserData,
    required this.userData,
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _loadCategories();
    _loadEvents();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final session = await widget.storage.read(key: "session");

    final result = await widget.userDataUseCase.sendGetUserDataRequest(session);
    
    widget.writeUserData?.call(result["data"]);
  }

  Future<void> _loadCategories() async {
    final session = await widget.storage.read(key: "session");

    final result = await widget.categoryUseCase.sendGetCategoriesRequest(
      session,
    );

    if (result["data"].keys.contains("categories")) {
      setState(() {
        widget.categories.clear();

        for (Map category in result["data"]["categories"]) {
          widget.categories.add(category);
        }
      });
    }
  }

  Future<void> _loadEvents() async {
    final session = await widget.storage.read(key: "session");

    final result = await widget.mainScreenEventUseCase.sendGetEventsRequest(
      session,
    );

    if (result["data"].keys.contains("events")) {
      setState(() {
        widget.events.clear();

        for (Map event in result["data"]["events"]) {
          widget.events.add(event);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _screens = [
      TodayScreen(
        events: widget.events,
        categories: widget.categories,
        onAllEventsTap: () {
          setState(() {
            _currentIndex = 1; // 1 - индекс страницы календаря
          });
        },
        calendarScreenEventUseCase: widget.calendarScreenEventUseCase,
        storage: widget.storage,
        removeEvent: widget.removeEvent,
        userData: widget.userData
      ),
      CalendarScreen(
        events: widget.events,
        categories: widget.categories,
        calendarScreenEventUseCase: widget.calendarScreenEventUseCase,
        storage: widget.storage,
        removeEvent: widget.removeEvent,
        userData: widget.userData,
      ),
      ProfileScreen(
        onPressed: widget.onPressed,
        profileCategoryUseCase: widget.profileCategoryUseCase,
        userDataUseCase: widget.userDataUseCase,
        storage: widget.storage,
        categories: widget.categories,
        removeCategory: widget.removeCategory,
        userData: widget.userData,
        writeUserData: widget.writeUserData
      ),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF1F0FB),
      body: _screens[_currentIndex],
      bottomNavigationBar: AppNavigationBar(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
