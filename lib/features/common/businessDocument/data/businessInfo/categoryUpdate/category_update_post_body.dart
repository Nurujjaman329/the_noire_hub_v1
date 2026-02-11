class CategoryUpdatePostBody {
  final List<SelectedCategory> selectedCategories;

  CategoryUpdatePostBody({
    required this.selectedCategories,
  });

  factory CategoryUpdatePostBody.fromJson(Map<String, dynamic> json) {
    return CategoryUpdatePostBody(
      selectedCategories: (json['selectedCategories'] as List?)
          ?.map((e) => SelectedCategory.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "selectedCategories":
      selectedCategories.map((e) => e.toJson()).toList(),
    };
  }
}

class SelectedCategory {
  final String category;
  final List<String> subcategories;

  SelectedCategory({
    required this.category,
    required this.subcategories,
  });

  factory SelectedCategory.fromJson(Map<String, dynamic> json) {
    return SelectedCategory(
      category: json['category'] ?? '',
      subcategories:
      (json['subcategories'] as List?)?.map((e) => e.toString()).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category": category,
      "subcategories": subcategories,
    };
  }
}
