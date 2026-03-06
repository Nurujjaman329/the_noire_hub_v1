import 'dart:convert';
import 'package:dio/dio.dart';

class BusinessInfoUpdateFormBody {
  final String? businessName;
  final String? bio;
  final String? phoneNumber;
  final List<BusinessAddressBody>? addresses;
  final String? imagePath; // optional

  BusinessInfoUpdateFormBody({
     this.businessName,
     this.bio,
     this.phoneNumber,
     this.addresses,
    this.imagePath,
  });

  /// Convert to Multipart FormData
  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {};

    // Only add values if they are NOT null
    if (businessName != null) map['businessName'] = businessName;
    if (bio != null) map['bio'] = bio;
    if (phoneNumber != null) map['phoneNumber'] = phoneNumber;

    // Only encode addresses if they are provided
    if (addresses != null) {
      map['addresses'] = jsonEncode(
        addresses!.map((e) => e.toJson()).toList(),
      );
    }

    // Handle Image
    if (imagePath != null && imagePath!.isNotEmpty) {
      map['shopImage'] = await MultipartFile.fromFile(
        imagePath!,
        filename: imagePath!.split('/').last,
      );
    }

    return FormData.fromMap(map);
  }

}
class BusinessAddressBody {
  final String city;
  final String country;
  final double longitude;
  final double latitude;

  BusinessAddressBody({
    required this.city,
    required this.country,
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "city": city,
      "country": country,
      "location": {
        "type": "Point",
        "coordinates": [longitude, latitude]
      }
    };
  }
}
