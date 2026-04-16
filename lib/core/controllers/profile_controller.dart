import 'package:get/get.dart';
import '../services/cache_service.dart';

/// Reactive profile controller that holds observable profile data
/// This allows UI to rebuild automatically when profile is updated
class ProfileController extends GetxController {
  var userImage = ''.obs;
  var userFullName = ''.obs;
  var businessName = ''.obs;
  var phone = ''.obs;
  var bio = ''.obs;
  var address = ''.obs;
  var lat = 0.0.obs;
  var lon = 0.0.obs;
  var role = ''.obs;
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFromCache();
  }

  void loadFromCache() {
    userImage.value = CacheService.userImage;
    userFullName.value = CacheService.userFullName;
    businessName.value = CacheService.businessName;
    phone.value = CacheService.phone;
    bio.value = CacheService.bio;
    address.value = CacheService.address;
    lat.value = CacheService.lat;
    lon.value = CacheService.lon;
    role.value = CacheService.role;
    userId.value = CacheService.userId;
  }

  /// Call this after updating profile to refresh all UI
  void refreshProfile() {
    loadFromCache();
    update();
  }

  /// Update specific fields and trigger UI rebuild
  void updateProfile({
    String? image,
    String? fullName,
    String? businessName,
    String? phone,
    String? bio,
    String? address,
    double? lat,
    double? lon,
  }) {
    if (image != null) userImage.value = image;
    if (fullName != null) userFullName.value = fullName;
    if (businessName != null) this.businessName.value = businessName;
    if (phone != null) this.phone.value = phone;
    if (bio != null) this.bio.value = bio;
    if (address != null) this.address.value = address;
    if (lat != null) this.lat.value = lat;
    if (lon != null) this.lon.value = lon;
    update();
  }

  String get formattedLocation {
    final String fullAddress = address.value;
    if (fullAddress.isEmpty) return '';

    final parts = fullAddress.split('|');
    if (parts.length == 2) {
      final city = parts[0].trim();
      final country = parts[1].trim();

      if (city.isNotEmpty && country.isNotEmpty) return '$city, $country';
      return city.isNotEmpty ? city : country;
    }
    return fullAddress;
  }

  String get fullImageUrl {
    return userImage.value.isNotEmpty
        ? 'https://tonmoy3000.sobhoy.com/api/v1/images/${userImage.value}'
        : '';
  }
}
