import 'package:journal_app/features/auth_screen/domain/repositories/auth_repository.dart';

class AuthorizeUseCase {
  final AuthRepository repository;

  AuthorizeUseCase({required this.repository});

  Future<Map<String, dynamic>> call(Map enteredData) async {
    return await repository.sendAuthorizeRequest(enteredData);
  }
}
