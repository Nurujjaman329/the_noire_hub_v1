class ApiConstants {
  static const String baseUrl = '7';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer <token>',  // optional, can set dynamically in interceptor
  };

  static const String registration = "${baseUrl}auth/register";
  static const String login = "${baseUrl}auth/login";

}
