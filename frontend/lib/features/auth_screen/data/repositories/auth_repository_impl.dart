import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:journal_app/core/app_config.dart';
import 'package:journal_app/features/auth_screen/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Map<String, dynamic>> sendRegisterRequest(Map enteredData) async {
    try {
      final response = await http
          .post(AppConfig.api("/register"), body: enteredData)
          .timeout(const Duration(seconds: 10));

      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode >= 400) {
        return {
          "success": false,
          "error": data["error"],
          "field": data["field"],
        };
      }

      return {"success": true, "data": data};
    } on TimeoutException {
      developer.log("Timeout", name: "AuthRepositoryImpl.sendRegisterRequest");
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    } catch (error, stackTrace) {
      developer.log(
        "Request failed",
        name: "AuthRepositoryImpl.sendRegisterRequest",
        error: error,
        stackTrace: stackTrace,
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    }
  }

  @override
  Future<Map<String, dynamic>> sendAuthenticateRequest(String? session) async {
    try {
      final response = await http
          .get(
            AppConfig.api("/authenticate"),
            headers: {"Cookie": "session=$session"},
          )
          .timeout(const Duration(seconds: 10));

      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode >= 400) {
        return {"authenticated": false};
      }

      return {"authenticated": true, "user_id": data["user_id"]};
    } on TimeoutException {
      developer.log(
        "Timeout",
        name: "AuthRepositoryImpl.sendAuthenticateRequest",
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    } catch (error, stackTrace) {
      developer.log(
        "Request failed",
        name: "AuthRepositoryImpl.sendAuthenticateRequest",
        error: error,
        stackTrace: stackTrace,
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    }
  }

  @override
  Future<Map<String, dynamic>> sendAuthorizeRequest(Map enteredData) async {
    try {
      final response = await http
          .post(AppConfig.api("/authorize"), body: enteredData)
          .timeout(const Duration(seconds: 10));

      Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode >= 400) {
        return {
          "success": false,
          "error": data["error"],
          "field": data["field"],
        };
      }
      // session=...; HttpOnly; Path=/
      // .split(";").first - берем «session=...» (из примера выше)
      // .split("=").last - из полученного «session=...» получаем «...» (ключ сессии)
      String session = response.headers["set-cookie"]!
          .split(";")
          .first
          .split("=")
          .last;

      return {"success": true, "data": data, "session": session};
    } on TimeoutException {
      developer.log("Timeout", name: "AuthRepositoryImpl.sendAuthorizeRequest");
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    } catch (error, stackTrace) {
      developer.log(
        "Request failed",
        name: "AuthRepositoryImpl.sendAuthorizeRequest",
        error: error,
        stackTrace: stackTrace,
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    }
  }
}
