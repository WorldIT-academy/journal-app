import 'package:journal_app/features/profile_screen/domain/repositories/profile_category_repository.dart';

class ProfileCategoryUseCase {
  ProfileCategoryRepository repository;

  ProfileCategoryUseCase({required this.repository});
  
  Future<Map<String, dynamic>> sendDeleteCategoryRequest(int id, String? session) async {
    return await repository.deleteCategory(id, session);
  }
}
