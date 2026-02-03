class OtpVerificationResponseModel {
  final int code;
  final String message;
  final LoginData data;

  OtpVerificationResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory OtpVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: LoginData.fromJson(json['data'] ?? {}),
    );
  }
}
class LoginData {
  final LoginAttributes attributes;

  LoginData({required this.attributes});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      attributes: LoginAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}
class LoginAttributes {
  final UserModel user;
  final TokenPair tokens;

  LoginAttributes({
    required this.user,
    required this.tokens,
  });

  factory LoginAttributes.fromJson(Map<String, dynamic> json) {
    return LoginAttributes(
      user: UserModel.fromJson(json['user'] ?? {}),
      tokens: TokenPair.fromJson(json['tokens'] ?? {}),
    );
  }
}
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String businessName;
  final String shopImage;
  final String bio;
  final String stripeAccountId;
  final String image;
  final String role;
  final String callingCode;
  final String phoneNumber;
  final String nidNumber;
  final bool isNIDVerified;
  final bool isProfileCompleted;
  final String dateOfBirth;
  final String createdAt;
  final List<UserCategory> selectedCategories;
  final List<UserAddress> addresses;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.businessName,
    required this.shopImage,
    required this.bio,
    required this.stripeAccountId,
    required this.image,
    required this.role,
    required this.callingCode,
    required this.phoneNumber,
    required this.nidNumber,
    required this.isNIDVerified,
    required this.isProfileCompleted,
    required this.dateOfBirth,
    required this.createdAt,
    required this.selectedCategories,
    required this.addresses,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Use .toString() to force ints or nulls into a String format
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      businessName: json['businessName']?.toString() ?? '',
      shopImage: json['shopImage']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      stripeAccountId: json['stripeAccountId']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      callingCode: json['callingCode']?.toString() ?? '',

      // This was definitely failing based on your log: phoneNumber: 1957073942
      phoneNumber: json['phoneNumber']?.toString() ?? '',

      nidNumber: json['nidNumber']?.toString() ?? '',

      // Keep bools as bools, but check for null
      isNIDVerified: json['isNIDVerified'] == true,
      isProfileCompleted: json['isProfileCompleted'] == true,

      dateOfBirth: json['dataOfBirth']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',

      selectedCategories: (json['selectedCategories'] as List<dynamic>? ?? [])
          .map((e) => UserCategory.fromJson(e))
          .toList(),
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .map((e) => UserAddress.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'email': email,
      'businessName': businessName,
      'shopImage': shopImage,
      'bio': bio,
      'stripeAccountId': stripeAccountId,
      'image': image,
      'role': role,
      'callingCode': callingCode,
      'phoneNumber': phoneNumber,
      'nidNumber': nidNumber,
      'isNIDVerified': isNIDVerified,
      'isProfileCompleted': isProfileCompleted,
      'dateOfBirth': dateOfBirth,
      'createdAt': createdAt,
      'selectedCategories': selectedCategories.map((e) => e.toJson()).toList(),
      'addresses': addresses.map((e) => e.toJson()).toList(),
    };
  }
}
class UserCategory {
  final String id;
  final String category;
  final List<String> subcategories;

  UserCategory({
    required this.id,
    required this.category,
    required this.subcategories,
  });

  factory UserCategory.fromJson(Map<String, dynamic> json) {
    return UserCategory(
      id: json['_id'] ?? '',
      category: json['category'] ?? '',
      subcategories: (json['subcategories'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category,
      'subcategories': subcategories,
    };
  }
}
class UserAddress {
  final Location location;
  final String city;
  final String country;
  final bool isDefault;
  final String id;

  UserAddress({
    required this.location,
    required this.city,
    required this.country,
    required this.isDefault,
    required this.id,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      location: Location.fromJson(json['location'] ?? {}),
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['isDefault'] ?? false,
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'city': city,
      'country': country,
      'isDefault': isDefault,
      '_id': id,
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: List<double>.from(
        (json['coordinates'] as List<dynamic>? ?? [])
            .map((e) => (e as num).toDouble()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

}
class TokenPair {
  final Token access;
  final Token refresh;

  TokenPair({
    required this.access,
    required this.refresh,
  });

  factory TokenPair.fromJson(Map<String, dynamic> json) {
    return TokenPair(
      access: Token.fromJson(json['access'] ?? {}),
      refresh: Token.fromJson(json['refresh'] ?? {}),
    );
  }
}

class Token {
  final String token;
  final String expires;

  Token({
    required this.token,
    required this.expires,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'] ?? '',
      expires: json['expires'] ?? '',
    );
  }
}
