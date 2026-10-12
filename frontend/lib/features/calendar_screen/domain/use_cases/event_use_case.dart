import 'package:journal_app/features/calendar_screen/domain/repositories/event_repository.dart';

class CalendarScreenEventUseCase {
  final CalendarScreenEventRepository repository;

  CalendarScreenEventUseCase({required this.repository});

  Future<Map<String, dynamic>> sendEventDeleteRequest(
    int id,
    String? session,
  ) async {
    return await repository.sendEventDeleteRequest(id, session);
  }
}
