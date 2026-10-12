
abstract class AuthRepository {
  Future<Map<String, dynamic>> sendRegisterRequest(Map enteredData);
  Future<Map<String, dynamic>> sendAuthenticateRequest(String? session);
  Future<Map<String, dynamic>> sendAuthorizeRequest(Map enteredData);
}
