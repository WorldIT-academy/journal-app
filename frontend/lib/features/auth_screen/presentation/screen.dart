import 'package:flutter/material.dart';
import 'package:journal_app/features/auth_screen/domain/use_cases/authenticate_use_case.dart';
import 'package:journal_app/features/auth_screen/domain/use_cases/authorize_use_case.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:journal_app/features/auth_screen/domain/use_cases/register_use_case.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback enableAuthenticated;
  final VoidCallback disableAuthenticated;
  final RegisterUseCase registerUseCase;
  final AuthenticateUseCase authenticateUseCase;
  final AuthorizeUseCase authorizeUseCase;
  final FlutterSecureStorage storage;

  const AuthScreen({
    required this.enableAuthenticated,
    required this.disableAuthenticated,
    required this.registerUseCase,
    required this.authenticateUseCase,
    required this.authorizeUseCase,
    required this.storage,
    super.key,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  //
  String? _emailError;
  String? _passwordError;
  String? _passwordConfirmationError;

  // Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  // Repositories

  // Для отслеживания состояния страницы,
  //то есть: сейчас отображена форма регистрации или авторизации
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();

    _checkAuthentication();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();

    super.dispose();
  }

  Future<void> _checkAuthentication() async {
    final session = await widget.storage.read(key: "session");

    Map<String, dynamic> responseData = await widget.authenticateUseCase.call(
      session,
    );

    if (responseData.keys.contains("authenticated") &&
        responseData["authenticated"]) {
      widget.enableAuthenticated();
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      widget.disableAuthenticated();
      return;
    }

    // Реестрация
    if (_isLogin == false) {
      Map<String, dynamic> responseData = await widget.registerUseCase.call({
        "email": _emailController.text,
        "password": _passwordController.text,
        "confirm_password": _passwordConfirmationController.text,
      });

      if (responseData.keys.contains("error")) {
        setState(() {
          if (responseData.keys.contains("field")) {
            _emailError = null;
            _passwordError = null;
            _passwordConfirmationError = null;

            if (responseData["field"] == "email") {
              _emailError = responseData["error"];
            } else if (responseData["field"] == "password") {
              _passwordError = responseData["error"];
            } else if (responseData["field"] == "confirm_password") {
              _passwordConfirmationError = responseData["error"];
            }
          }
        });
      }

      if (responseData.keys.contains("success") && responseData["success"]) {
        setState(() {
          _emailError = null;
          _passwordError = null;
          _passwordConfirmationError = null;

          _isLogin = true;

          _emailController.clear();
          _passwordController.clear();
          _passwordConfirmationController.clear();
        });
      }

      // Авторизация
    } else if (_isLogin == true) {
      Map<String, dynamic> responseData = await widget.authorizeUseCase.call({
        "email": _emailController.text,
        "password": _passwordController.text,
      });

      _emailError = null;
      _passwordError = null;
      _passwordConfirmationError = null;

      if (responseData.keys.contains("error")) {
        setState(() {
          if (responseData.keys.contains("field")) {
            if (responseData["field"] == "email") {
              _emailError = responseData["error"];
            } else if (responseData["field"] == "password") {
              _passwordError = responseData["error"];
            }
          }
        });
      }

      if (responseData.keys.contains("success") && responseData["success"]) {
        setState(() {
          _emailError = null;
          _passwordError = null;
          _passwordConfirmationError = null;

          _emailController.clear();
          _passwordController.clear();
          _passwordConfirmationController.clear();

          // Сохраняем сессию в локальном хранилище
          widget.storage.write(key: "session", value: responseData["session"]);

          // Отображаем основные страницы
          widget.enableAuthenticated();
        });
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введіть email';
    }

    if (!value.contains('@')) {
      return 'Введіть коректний email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введіть пароль';
    }

    if (value.length < 8) {
      return 'Пароль має містити щонайменше 8 символів';
    }

    return null;
  }

  String? _validatePasswordConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Підтвердіть пароль';
    }

    if (value != _passwordController.text) {
      return 'Паролі не збігаються';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0FB), // tema
      body: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD9D9E2)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLogin ? 'Авторизація' : 'Реєстрація',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 22),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Пошта',
                    errorText: _emailError,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8585B0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 13,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFDCDCE8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF9999C8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFD85C5C)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFD85C5C)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: _validatePassword,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    errorText: _passwordError,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF8585B0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 13,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFDCDCE8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF9999C8)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFD85C5C)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFD85C5C)),
                    ),
                  ),
                ),
                if (!_isLogin) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordConfirmationController,
                    obscureText: true,
                    validator: _validatePasswordConfirmation,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      labelText: 'Підтвердження паролю',
                      errorText: _passwordConfirmationError,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8585B0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 13,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFDCDCE8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF9999C8)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFD85C5C)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFD85C5C)),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9999C8),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ), 
                    ),
                    child: Text(
                      _isLogin ? 'Увійти' : 'Зареєструватися',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    _isLogin
                        ? 'Немає облікового запису? Реєстрація'
                        : 'Вже є обліковий запис? Авторизація',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8585B0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
