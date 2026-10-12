abstract class ProfileCategoryRepository {
  Future<Map<String, dynamic>> deleteCategory(int id, String? session);
}
