

abstract class CalendarScreenEventRepository {
  Future<Map<String, dynamic>> sendEventDeleteRequest(int id, String? session);
}
