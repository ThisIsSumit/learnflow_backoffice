class Env {
  static const String apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'localhost:5000');
}
