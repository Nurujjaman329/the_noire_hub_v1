class ApiConstants {
  static const String baseUrl = 'http://10.10.11.88:3000/api/v1/';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer <token>',  // optional, can set dynamically in interceptor
  };

  static const String registration = "${baseUrl}auth/register";

}
