import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:journal_app/core/app_config.dart';
import 'package:journal_app/features/profile_screen/domain/repositories/user_data_repository.dart';

class UserDataRepositoryImpl implements UserDataRepository {
  @override
  Future<Map<String, dynamic>> sendGetUserDataRequest(String? session) async {
    try {
      final response = await http
          .get(AppConfig.api("/user"), headers: {"Cookie": "session=$session"})
          .timeout(const Duration(seconds: 10));

      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode >= 400) {
        return {"success": false, "data": data};
      }

      return {"success": true, "data": data};
    } on TimeoutException {
      developer.log(
        "Timeout",
        name: "ProfileCategoryUseCaseImpl.deleteCategory",
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    } catch (error, stackTrace) {
      developer.log(
        "Request failed",
        name: "ProfileCategoryUseCaseImpl.deleteCategory",
        error: error,
        stackTrace: stackTrace,
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    }
  }

  @override
  Future<Map<String, dynamic>> sendUpdateUserDataRequest(
    Map<String, String> enteredData,
    String? session,
  ) async {
    try {
      final response = await http
          .put(
            AppConfig.api("/user"),
            headers: {"Cookie": "session=$session"},
            body: enteredData,
          )
          .timeout(const Duration(seconds: 10));

      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode >= 400) {
        return {"success": false, "data": data};
      }

      return {"success": true, "data": data};
    } on TimeoutException {
      developer.log(
        "Timeout",
        name: "ProfileCategoryUseCaseImpl.deleteCategory",
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    } catch (error, stackTrace) {
      developer.log(
        "Request failed",
        name: "ProfileCategoryUseCaseImpl.deleteCategory",
        error: error,
        stackTrace: stackTrace,
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    }
  }
}
