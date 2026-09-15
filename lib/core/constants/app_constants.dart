class AppConstants {
  static const String appName = 'The Noire Hub';
  static const String version = '1.0.0';
  static const String baseUrl = 'https://api.thenoirehub.com';
  static const String apiVersion = 'v1';
  
  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String onboardingKey = 'onboarding_completed';
  
  // Validation patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^\+?[\d\s\-\(\)]+$';
  static const String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';
  
  // Time constants
  static const int cacheDuration = 300; // 5 minutes in seconds
  static const int sessionTimeout = 1800; // 30 minutes in seconds
  static const int retryAttempts = 3;
  
  // Pagination
  static const int pageSize = 20;
  
  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double borderRadius = 8.0;
  static const double buttonHeight = 48.0;

  /// Shared checkout / booking fees (service + product).
  /// Example: amount 100 → fee 4 + GST 5 → total 109.
  static const double serviceFeeRate = 0.04; // 4%
  static const double gstTaxRate = 0.05; // 5%

  static double roundMoney(double value) =>
      double.parse(value.toStringAsFixed(2));

  static double serviceFeeFor(double amount) =>
      roundMoney(amount * serviceFeeRate);

  static double gstTaxFor(double amount) =>
      roundMoney(amount * gstTaxRate);

  static double totalWithFeesAndTax(double amount) =>
      roundMoney(amount + serviceFeeFor(amount) + gstTaxFor(amount));
  
  // Network timeouts (in milliseconds)
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
  
  // Error messages
  static const String networkError = 'Network error occurred';
  static const String serverError = 'Server error occurred';
  static const String unknownError = 'An unknown error occurred';
  static const String timeoutError = 'Request timed out';
  static const String badCertificateError = 'SSL certificate error';
  static const String connectionError = 'Connection error';
  static const String connectionTimeoutError = 'Connection timeout';
  static const String receiveTimeoutError = 'Receive timeout';
  static const String sendTimeoutError = 'Send timeout';
  static const String cancelError = 'Request cancelled';
  
  // Success messages
  static const String successMessage = 'Operation completed successfully';
  
  // Cache keys
  static const String userCacheKey = 'user_cache';
  static const String productCacheKey = 'product_cache';
  static const String serviceCacheKey = 'service_cache';
  static const String categoryCacheKey = 'category_cache';
}