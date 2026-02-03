class ApiConstants {
  //common

  static const String baseUrl = 'http://10.10.11.88:3000/api/v1/';
  static const String imageUrl = 'http://10.10.11.88:3000/';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String registration = "${baseUrl}auth/register";
  static const String login = "${baseUrl}auth/login";
  static const String categories = "${baseUrl}categories";

  //customer



  //beauticians

  //vendor
}
