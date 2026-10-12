import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:journal_app/core/app_config.dart';
import 'package:journal_app/features/main_screen/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<Map<String, dynamic>> getCategories(String? session) async {
    try {
      final response = await http
          .get(
            AppConfig.api("/categories"),
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
        name: "CategoryRepositoryImpl.getCategories",
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    } catch (error, stackTrace) {
      developer.log(
        "Request failed",
        name: "CategoryRepositoryImpl.getCategories",
        error: error,
        stackTrace: stackTrace,
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    }
  }
  
  @override
  Future<Map<String, dynamic>> sendCategoryCreateRequest(
    Map<String, String> enteredData,
    String? session
  ) async {
    try {

      final response = await http
          .post(
            AppConfig.api("/categories"),
            body: enteredData,
            headers: {"Cookie": "session=$session"},
          )
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
      developer.log(
        "Timeout",
        name: "CategoryRepositoryImpl.sendCategoryCreateRequest",
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    } catch (error, stackTrace) {
      developer.log(
        "Request failed",
        name: "CategoryRepositoryImpl.sendCategoryCreateRequest",
        error: error,
        stackTrace: stackTrace,
      );
      return {"success": false, "error": "Помилка зʼєднання з сервером"};
    }
  }
}