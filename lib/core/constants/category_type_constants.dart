import '../services/cache_service.dart';

/// API values for `categoryType` query param on categories/subcategories endpoints.
class CategoryTypeConstants {
  CategoryTypeConstants._();

  static const String product = 'product';
  static const String service = 'service';

  /// Maps vendor / beautician registration or session role to API categoryType.
  static String forVendorOrBeauticianRole(String role) {
    final normalized = role.toLowerCase();
    if (normalized.contains('beautician')) return service;
    if (normalized.contains('vendor')) return product;
    return product;
  }

  /// Uses logged-in role from cache (vendor → product, beautician → service).
  static String forCurrentBusinessRole() {
    return forVendorOrBeauticianRole(CacheService.role);
  }

  static bool isBusinessRole(String role) {
    final normalized = role.toLowerCase();
    return normalized.contains('vendor') || normalized.contains('beautician');
  }
}
