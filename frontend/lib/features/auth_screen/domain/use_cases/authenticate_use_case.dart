import 'package:journal_app/features/auth_screen/domain/repositories/auth_repository.dart';

class AuthenticateUseCase {
  final AuthRepository repository;

  AuthenticateUseCase({required this.repository});

  Future<Map<String, dynamic>> call(String? session) async {
    return await repository.sendAuthenticateRequest(session);
  }
}
