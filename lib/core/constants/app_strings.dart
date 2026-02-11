
class AppStrings {
  // Private constructor to prevent instantiation
  AppStrings._();

  // Search
  static const String searchHint = 'Search food or restaurant here...';

  // Section headers
  static const String categories = 'Categories';
  static const String popularFoodNearby = 'Popular Food Nearby';
  static const String foodCampaign = 'Food Campaign';
  static const String restaurants = 'Restaurants';
  static const String viewAll = 'View All';

  // Error messages
  static const String noInternetConnection = 'No Internet Connection';
  static const String noInternetMessage =
      'No internet connection. Please try again.';
  static const String oops = 'Oops!';
  static const String retry = 'Retry';
  static const String loadMoreFailed = 'Load More Failed';
  static const String requestTimeout = 'Request timeout. Please try again';
  static const String serverError = 'Server error';
  static const String unexpectedError = 'An unexpected error occurred';
  static const String failedToLoadData = 'Failed to load data';

  // Placeholders
  static const String unknownProduct = 'Unknown Product';
  static const String unknownRestaurant = 'Unknown Restaurant';
  static const String unknownCategory = 'Unknown Category';

  // Address
  static const String defaultAddress = '76A eight avenue, New York, US';

  // Cache messages
  static const String cacheNotInitialized =
      'Cache service not initialized. Call init() first.';
}
