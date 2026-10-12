import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:journal_app/core/app_config.dart';
import 'package:journal_app/features/calendar_screen/domain/repositories/event_repository.dart';

class CalendarScreenEventRepositoryImpl
    implements CalendarScreenEventRepository {
  @override
  Future<Map<String, dynamic>> sendEventDeleteRequest(
    int id,
    String? session,
  ) async {
    try {
      final response = await http
          .delete(
            AppConfig.api("/events/$id"),
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
        name: "CalendarScreenEventRepositoryImpl.sendEventDeleteRequest",
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    } catch (error, stackTrace) {
      developer.log(
        "Request failed",
        name: "CalendarScreenEventRepositoryImpl.sendEventDeleteRequest",
        error: error,
        stackTrace: stackTrace,
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    }
  }
}
