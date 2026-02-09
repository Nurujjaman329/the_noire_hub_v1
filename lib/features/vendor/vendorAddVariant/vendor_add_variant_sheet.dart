import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../core/widgets/custom_text.dart';
import '../vendorAddProduct/data/vendor_add_product_post_body.dart';
import '../vendorAddProduct/presentation/controller/vendor_add_product_controller.dart';

class VendorAddVariantSheet extends StatefulWidget {
  const VendorAddVariantSheet({super.key});

  @override
  State<VendorAddVariantSheet> createState() => _VendorAddVariantSheetState();
}

class _VendorAddVariantSheetState extends State<VendorAddVariantSheet> {
  // Store all variant data in a list of maps
  List<Map<String, dynamic>> variants = [
    {
      "weight": TextEditingController(),
      "price": TextEditingController(),
      "unit": "g",
      "color": const Color(0xFF1D3826)
    }
  ];

  // Matches your Dio: 'variants[color]': '0XFF000000'
  String colorToHex(Color color) {
    return '0X${color.value.toRadixString(16).toUpperCase()}';
  }

  void _addNewVariant() {
    setState(() {
      variants.add({
        "weight": TextEditingController(),
        "price": TextEditingController(),
        "unit": "g",
        "color": const Color(0xFF1D3826)
      });
    });
  }

  // Dynamic Color Picker Dialog
  void _pickColor(int index) {
    Color tempColor = variants[index]['color'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick a color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: variants[index]['color'],
            onColorChanged: (color) => tempColor = color,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => variants[index]['color'] = tempColor);
              Navigator.pop(context);
            },
            child: const Text("Select"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var v in variants) {
      v["weight"].dispose();
      v["price"].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close, size: 28.sp)),
            ),
            CustomText(text: "Product Variants", fontSize: 18.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 15.h),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: variants.length,
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    // Weight Value
                    Expanded(
                      flex: 3,
                      child: _buildInputContainer(
                        child: TextField(
                          controller: variants[index]['weight'],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: "Weight", border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),

                    // Unit Dropdown
                    _buildUnitDropdown(index),
                    SizedBox(width: 5.w),

                    // Price
                    Expanded(
                      flex: 3,
                      child: _buildInputContainer(
                        child: TextField(
                          controller: variants[index]['price'],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: "Price \$", border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Dynamic Color Circle
                    GestureDetector(
                      onTap: () => _pickColor(index),
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: variants[index]['color'],
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Icon(Icons.colorize, color: Colors.white, size: 14.sp),
                      ),
                    ),

                    if (variants.length > 1)
                      IconButton(
                        onPressed: () => setState(() => variants.removeAt(index)),
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      ),
                  ],
                );
              },
            ),

            SizedBox(height: 20.h),
            GestureDetector(
              onTap: _addNewVariant,
              child: Row(
                children: [
                  const Icon(Icons.add_circle, color: Color(0xFF1D3826)),
                  SizedBox(width: 10.w),
                  CustomText(text: "Add New Variant", fontSize: 16.sp, fontWeight: FontWeight.bold),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            _buildSaveButton(),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitDropdown(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFCADA9F).withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: variants[index]['unit'],
          items: ["g", "kg", "ml", "liter"].map((u) => DropdownMenuItem(
              value: u,
              child: Text(u, style: TextStyle(fontSize: 12.sp))
          )).toList(),
          onChanged: (v) => setState(() => variants[index]['unit'] = v!),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1D3826),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
        onPressed: () {
          final productController = Get.find<VendorAddProductController>();

          // Clear old variants
          productController.selectedVariants.clear();

          for (final v in variants) {
            // Basic validation (optional but recommended)
            if (v['weight'].text.trim().isEmpty ||
                v['price'].text.trim().isEmpty) {
              continue;
            }

            productController.selectedVariants.add(
              ProductVariantBody(
                color: colorToHex(v['color']),
                price: double.tryParse(v['price'].text) ?? 0.0,
                weight: double.tryParse(v['weight'].text) ?? 0.0,
                unit: v['unit'],
              ),
            );
          }

          Get.back();
        },

        child: const Text("Save Variants", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFCADA9F).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }
}