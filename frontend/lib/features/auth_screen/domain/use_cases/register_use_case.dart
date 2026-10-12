import 'package:journal_app/features/auth_screen/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<Map<String, dynamic>> call(Map enteredData) async {
    return await repository.sendRegisterRequest(enteredData);
  }
}
