class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "http://127.0.0.1:8080",
  );

  static Uri api(String path) => Uri.parse("$apiBaseUrl$path");
}
