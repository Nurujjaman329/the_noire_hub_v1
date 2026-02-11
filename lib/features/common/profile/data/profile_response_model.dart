//
//
// class ProfileResponseModel {
//   final int code;
//   final String message;
//   final UserProfileData data;
//
//   ProfileResponseModel({
//     required this.code,
//     required this.message,
//     required this.data,
//   });
//
//   factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
//     return ProfileResponseModel(
//       code: json['code'] ?? 0,
//       message: json['message'] ?? '',
//       data: UserProfileData.fromJson(json['data'] ?? {}),
//     );
//   }
// }
//
// class UserProfileData {
//   final UserProfileAttributes attributes;
//
//   UserProfileData({required this.attributes});
//
//   factory UserProfileData.fromJson(Map<String, dynamic> json) {
//     return UserProfileData(
//       attributes: UserProfileAttributes.fromJson(json['attributes'] ?? {}),
//     );
//   }
// }
//
// class UserProfileAttributes {
//   final UserProfileModel user;
//
//   UserProfileAttributes({required this.user});
//
//   factory UserProfileAttributes.fromJson(Map<String, dynamic> json) {
//     return UserProfileAttributes(
//       user: UserProfileModel.fromJson(json['user'] ?? {}),
//     );
//   }
// }
//
// class UserProfileModel {
//   final String id;
//   final String fullName;
//   final String email;
//   final String businessName;
//   final String shopImage;
//   final String bio;
//   final String image;
//   final String role;
//   final String? phoneNumber;
//   final bool isProfileCompleted;
//   final DateTime? createdAt;
//   final List<UserCategory> selectedCategories;
//   final List<UserAddress> addresses;
//
//   UserProfileModel({
//     required this.id,
//     required this.fullName,
//     required this.email,
//     required this.businessName,
//     required this.shopImage,
//     required this.bio,
//     required this.image,
//     required this.role,
//     this.phoneNumber,
//     required this.isProfileCompleted,
//     this.createdAt,
//     required this.selectedCategories,
//     required this.addresses,
//   });
//
//   factory UserProfileModel.fromJson(Map<String, dynamic> json) {
//     return UserProfileModel(
//       id: json['id'] ?? '',
//       fullName: json['fullName'] ?? '',
//       email: json['email'] ?? '',
//       businessName: json['businessName'] ?? '',
//       shopImage: json['shopImage'] ?? '',
//       bio: json['bio'] ?? '',
//       image: json['image'] ?? '',
//       role: json['role'] ?? '',
//       phoneNumber: json['phoneNumber']?.toString(),
//       isProfileCompleted: json['isProfileCompleted'] ?? false,
//       createdAt: json['createdAt'] != null
//           ? DateTime.tryParse(json['createdAt'])
//           : null,
//       selectedCategories: (json['selectedCategories'] as List<dynamic>? ?? [])
//           .map((e) => UserCategory.fromJson(e))
//           .toList(),
//       addresses: (json['addresses'] as List<dynamic>? ?? [])
//           .map((e) => UserAddress.fromJson(e))
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'fullName': fullName,
//       'email': email,
//       'businessName': businessName,
//       'shopImage': shopImage,
//       'bio': bio,
//       'image': image,
//       'role': role,
//       'phoneNumber': phoneNumber,
//       'isProfileCompleted': isProfileCompleted,
//       'createdAt': createdAt?.toIso8601String(),
//       'selectedCategories': selectedCategories.map((e) => e.toJson()).toList(),
//       'addresses': addresses.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class UserCategory {
//   final String id;
//   final String category;
//   final List<String> subcategories;
//
//   UserCategory({
//     required this.id,
//     required this.category,
//     required this.subcategories,
//   });
//
//   factory UserCategory.fromJson(Map<String, dynamic> json) {
//     return UserCategory(
//       id: json['_id'] ?? '',
//       category: json['category'] ?? '',
//       subcategories: (json['subcategories'] as List<dynamic>? ?? [])
//           .map((e) => e.toString())
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'category': category,
//       'subcategories': subcategories,
//     };
//   }
// }
//
// class UserAddress {
//   final Location location;
//   final String city;
//   final String country;
//   final bool isDefault;
//   final String id;
//
//   UserAddress({
//     required this.location,
//     required this.city,
//     required this.country,
//     required this.isDefault,
//     required this.id,
//   });
//
//   factory UserAddress.fromJson(Map<String, dynamic> json) {
//     return UserAddress(
//       location: Location.fromJson(json['location'] ?? {}),
//       city: json['city'] ?? '',
//       country: json['country'] ?? '',
//       isDefault: json['isDefault'] ?? false,
//       id: json['_id'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'location': location.toJson(),
//       'city': city,
//       'country': country,
//       'isDefault': isDefault,
//       '_id': id,
//     };
//   }
// }
//
// class Location {
//   final String type;
//   final List<double> coordinates;
//
//   Location({
//     required this.type,
//     required this.coordinates,
//   });
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       type: json['type'] ?? '',
//       coordinates: List<double>.from(
//           (json['coordinates'] as List<dynamic>? ?? []).map((e) => (e as num).toDouble())),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'coordinates': coordinates,
//     };
//   }
// }
