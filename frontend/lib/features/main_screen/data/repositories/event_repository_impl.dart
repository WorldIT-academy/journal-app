import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:journal_app/core/app_config.dart';
import 'package:journal_app/features/main_screen/domain/repositories/event_repository.dart';

class MainScreenEventRepositoryImpl implements MainScreenEventRepository {
  @override
  Future<Map<String, dynamic>> getEvents(String? session) async {
    try {
      final response = await http
          .get(
            AppConfig.api("/events"),
            headers: {"Cookie": "session=$session"},
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
        name: "MainScreenEventRepositoryImpl.getEvents",
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    } catch (error, stackTrace) {
      developer.log(
        "Request failed",
        name: "MainScreenEventRepositoryImpl.getEvents",
        error: error,
        stackTrace: stackTrace,
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    }
  }

  @override
  Future<Map<String, dynamic>> sendCreateEventRequest(
    Map<String, dynamic> enteredData,
    String? session,
  ) async {
    try {
      final response = await http
          .post(
            AppConfig.api("/events"),
            body: enteredData,
            headers: {"Cookie": "session=$session"},
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
        name: "MainScreenEventRepositoryImpl.sendCreateEventRequest",
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    } catch (error, stackTrace) {
      developer.log(
        "Request failed",
        name: "MainScreenEventRepositoryImpl.sendCreateEventRequest",
        error: error,
        stackTrace: stackTrace,
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    }
  }
}