import 'package:journal_app/features/main_screen/domain/repositories/category_repository.dart';

class CategoryUseCase {
  final CategoryRepository repository;

  CategoryUseCase({required this.repository});

  Future<Map<String, dynamic>> sendCreateCategoryRequest(Map<String, String> enteredData, String? session) async {
    return await repository.sendCategoryCreateRequest(enteredData, session);
  }

  Future<Map<String, dynamic>> sendGetCategoriesRequest(String? session) async {
    return await repository.getCategories(session);
  }
}
