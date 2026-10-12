import 'package:journal_app/features/profile_screen/domain/repositories/user_data_repository.dart';

class UserDataUseCase {
  UserDataRepository repository;

  UserDataUseCase({required this.repository});

  Future<Map<String, dynamic>> sendGetUserDataRequest(String? session) {
    return repository.sendGetUserDataRequest(session);
  }
  
  Future<Map<String, dynamic>> sendUpdateUserDataRequest(Map<String, String> enteredData, String? session) {
    return repository.sendUpdateUserDataRequest(enteredData, session);
  }
}
