class ApiConstants {
  //common

  static const String baseUrl = 'http://10.10.11.88:3000/api/v1/';
  static const String imageUrl = 'http://10.10.11.88:3000';
  static const String baseImageUrl = imageUrl;

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String registration = "auth/register";
  static const String login = "auth/login";
  static const String categories = "categories";
  static const String subCategories = "subcategories";
  static const String verifyOtp = "auth/verify-email";
  static const String resendOtp = "auth/resend-otp";
  static const String verifyMail = "auth/forgot-password";
  static const String resetPassword = "auth/reset-password";
  static const String changePassword = "auth/change-password";
  static const String getProfile = "users/self/in";
  static const String updateProfile = "users/self/update";

  //customer



  //beauticians

  //vendor
}
