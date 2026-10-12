abstract class MainScreenEventRepository {
  Future<Map<String, dynamic>> sendCreateEventRequest(
    Map<String, dynamic> enteredData,
    String? session,
  );

  Future<Map<String, dynamic>> getEvents(String? session);
}
