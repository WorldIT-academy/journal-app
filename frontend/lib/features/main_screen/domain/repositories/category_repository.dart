abstract class CategoryRepository {
  Future<Map<String, dynamic>> getCategories(String? session);
  Future<Map<String, dynamic>> sendCategoryCreateRequest(
    Map<String, String> enteredData,
    String? session
  );
}
