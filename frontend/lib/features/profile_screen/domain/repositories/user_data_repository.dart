abstract class UserDataRepository {
  Future<Map<String, dynamic>> sendGetUserDataRequest(String? session);
  Future<Map<String, dynamic>> sendUpdateUserDataRequest(
    Map<String, String> enteredData,
    String? session,
  );
}
