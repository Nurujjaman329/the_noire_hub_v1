// Helper for Location Coordinates
class LocationModel {
  final String type;
  final List<double> coordinates;

  LocationModel({this.type = "Point", required this.coordinates});

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates,
  };
}

// Helper for Address
class AddressRequest {
  final String country;
  final String city;
  final LocationModel location;

  AddressRequest({required this.country, required this.city, required this.location});

  Map<String, dynamic> toJson() => {
    "country": country,
    "city": city,
    "location": location.toJson(),
  };
}

// Helper for Vendor Categories
class SelectedCategoryRequest {
  final String category;
  final List<String> subcategories;

  SelectedCategoryRequest({required this.category, required this.subcategories});

  Map<String, dynamic> toJson() => {
    "category": category,
    "subcategories": subcategories,
  };
}