import 'package:flutter/material.dart';

class EditVariantSet {
  String? id; // Crucial for existing variants
  bool hasId; // Track if this variant has an existing ID
  TextEditingController nameController;
  TextEditingController descController;
  List<Map<String, TextEditingController>> subVariants;

  EditVariantSet({
    this.id,
    required String name,
    required String desc,
    required List<Map<String, TextEditingController>> existingSubs,
  })  : nameController = TextEditingController(text: name),
        descController = TextEditingController(text: desc),
        subVariants = existingSubs,
        hasId = id != null && id.isNotEmpty; // Check if ID exists and is not empty

  void addSubVariant() {
    subVariants.add({'name': TextEditingController(), 'price': TextEditingController()});
  }
}