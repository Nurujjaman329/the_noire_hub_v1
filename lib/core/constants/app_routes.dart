class AppRoutes {
  AppRoutes._();

  // Authentication routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerify = '/otp-verify';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Home routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';

  // Service routes
  static const String services = '/services';
  static const String serviceDetail = '/service-detail';
  static const String bookService = '/book-service';

  // Product routes
  static const String products = '/products';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  // Booking routes
  static const String bookings = '/bookings';
  static const String bookingDetail = '/booking-detail';

  // Settings routes
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  static const String helpCenter = '/help-center';
}