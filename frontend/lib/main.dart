import 'package:flutter/material.dart';
import 'package:journal_app/core/dependencies.dart';
import 'package:journal_app/features/auth_screen/domain/use_cases/authenticate_use_case.dart';
import 'package:journal_app/features/auth_screen/domain/use_cases/authorize_use_case.dart';
import 'package:journal_app/features/auth_screen/domain/use_cases/register_use_case.dart';
import 'package:journal_app/features/auth_screen/presentation/screen.dart';
import 'package:journal_app/features/calendar_screen/domain/use_cases/event_use_case.dart';
import 'package:journal_app/features/main_screen/domain/use_cases/category_use_case.dart';
import 'package:journal_app/features/main_screen/domain/use_cases/event_use_case.dart';
import 'package:journal_app/features/main_screen/presentation/screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:journal_app/features/main_screen/presentation/widgets/hud_radial_menu.dart';
import 'package:journal_app/features/profile_screen/domain/use_cases/profile_category_use_case.dart';
import 'package:journal_app/features/profile_screen/domain/use_cases/user_data_use_case.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = FlutterSecureStorage();

  bool _isAuthenticated = false;

  // Modals use cases
  late final CategoryUseCase _categoryUseCase;
  late final MainScreenEventUseCase _mainScreenEventUseCase;

  // Auth screen use cases
  late final RegisterUseCase _registerUseCase;
  late final AuthenticateUseCase _authenticateUseCase;
  late final AuthorizeUseCase _authorizeUseCase;

  // Profile screen use cases
  late final ProfileCategoryUseCase _profileCategoryUseCase;
  late final UserDataUseCase _userDataUseCase;

  // Calendar screen use cases
  late final CalendarScreenEventUseCase _calendarScreenEventUseCase;

  // Данные основных сущностей (события, категории),
  // используются на всех основных страницах (профиль, «сегодня», календарь)
  final List<Map> _categories = [];
  final List<Map> _events = [];
  Map _userData = {};

  @override
  void initState() {
    super.initState();

    // Modals use cases
    _categoryUseCase = createCategoryUseCase();
    _mainScreenEventUseCase = createMainScreenEventUseCase();

    // Auth screen use cases
    _registerUseCase = createRegisterUseCase();
    _authenticateUseCase = createAuthenticateUseCase();
    _authorizeUseCase = createAuthorizeUseCase();

    // Calendar screen use cases
    _calendarScreenEventUseCase = createCalendarScreenEventUseCase();

    // Profile screen use cases
    _profileCategoryUseCase = createProfileCategoryUseCase();
    _userDataUseCase = createUserDataUseCase();
  }

  // User data
  void _writeUserData(Map data) {
    setState(() {
      _userData = data;
    });
  }

  Future<void> _logout() async {
    await storage.delete(key: "session");

    setState(() {
      _isAuthenticated = false;
      _userData = {};
      _events.clear();
      _categories.clear();
    });
  }

  // Events
  void _addEvent(Map event) {
    setState(() {
      _events.add(event);
    });
  }

  void _removeEvent(int id) {
    setState(() {
      _events.removeWhere((event) => event["id"] == id);
    });
  }

  // Categories
  void _addCategory(Map category) {
    setState(() {
      _categories.add(category);
    });
  }

  void _removeCategory(int id) {
    setState(() {
      _categories.removeWhere((category) => category["id"] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isAuthenticated
          ? MainScreen(
              onPressed: () async {
                await storage.delete(key: "session");
                _logout();
              },
              categoryUseCase: _categoryUseCase,
              mainScreenEventUseCase: _mainScreenEventUseCase,
              calendarScreenEventUseCase: _calendarScreenEventUseCase,
              profileCategoryUseCase: _profileCategoryUseCase,
              userDataUseCase: _userDataUseCase,
              userData: _userData,
              writeUserData: _writeUserData,
              storage: storage,
              removeCategory: _removeCategory,
              removeEvent: _removeEvent,
              categories: _categories,
              events: _events,
            )
          : AuthScreen(
              enableAuthenticated: () {
                setState(() {
                  _isAuthenticated = true;
                });
              },
              disableAuthenticated: () {
                setState(() {
                  _isAuthenticated = false;
                });
              },
              registerUseCase: _registerUseCase,
              authenticateUseCase: _authenticateUseCase,
              authorizeUseCase: _authorizeUseCase,
              storage: storage,
            ),
      floatingActionButton: _isAuthenticated
          ? Stack(
              children: [
                HudRadialMenu(
                  categoryUseCase: _categoryUseCase,
                  mainScreenEventUseCase: _mainScreenEventUseCase,
                  storage: storage,
                  addCategory: _addCategory,
                  addEvent: _addEvent,
                  categories: _categories,
                  events: _events,
                  userData: _userData,
                ),
              ],
            )
          : null,
    );
  }
}
