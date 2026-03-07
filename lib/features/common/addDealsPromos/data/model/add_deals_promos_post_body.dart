class AddDealsPromosPostBody {
  final String code;
  final String title;
  final int discountPercentage;
  final String description;
  final String expiryDate;
  final String applicableFor;
  final int maxUsageCount;

  AddDealsPromosPostBody({
    required this.code,
    required this.title,
    required this.discountPercentage,
    required this.description,
    required this.expiryDate,
    required this.applicableFor,
    required this.maxUsageCount,
  });

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "title": title,
      "discountPercentage": discountPercentage,
      "description": description,
      "expiryDate": expiryDate,
      "applicableFor": applicableFor,
      "maxUsageCount": maxUsageCount,
    };
  }
}

// for edit

class EditDealsPromosPostBody {
  final String title;
  final String expiryDate;
  final String description;

  EditDealsPromosPostBody({
    required this.title,
    required this.expiryDate,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "expiryDate": expiryDate,
    "description": description,
  };
}