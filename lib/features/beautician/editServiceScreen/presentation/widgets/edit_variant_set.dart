import 'package:flutter/material.dart';

class EditVariantSet {
  String? id; // Crucial for existing variants
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
        subVariants = existingSubs;

  void addSubVariant() {
    subVariants.add({'name': TextEditingController(), 'price': TextEditingController()});
  }
}