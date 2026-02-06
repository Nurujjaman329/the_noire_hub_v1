import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/widgets/custom_text.dart';



class VendorAddVariantSheet extends StatefulWidget {
  const VendorAddVariantSheet({super.key});

  @override
  State<VendorAddVariantSheet> createState() => _VendorAddVariantSheetState();
}

class _VendorAddVariantSheetState extends State<VendorAddVariantSheet> {
  List<Map<String, dynamic>> variants = [
    {
      "size": TextEditingController(),
      "price": TextEditingController(),
      "color": const Color(0xFF3F592B)
    }
  ];

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  void _addNewVariant() {
    setState(() {
      variants.add({
        "size": TextEditingController(),
        "price": TextEditingController(),
        "color": const Color(0xFF1B3022)
      });
    });
  }

  void _pickColor(int index) {
    final List<Color> palette = [
      const Color(0xFF3F592B), const Color(0xFF1B3022), Colors.red,
      Colors.pink, Colors.purple, Colors.deepPurple, Colors.indigo,
      Colors.blue, Colors.lightBlue, Colors.cyan, Colors.teal,
      Colors.green, Colors.yellow, Colors.orange, Colors.brown, Colors.black,
      const Color(0xFFCADA9F), // matching your UI theme
    ];

    // You MUST call showDialog to make the picker appear
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(text: "Select Variant Color", fontSize: 16.sp, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: palette.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, pIndex) {
              return GestureDetector(
                onTap: () {
                  // This updates the specific variant in your list
                  setState(() {
                    variants[index]['color'] = palette[pIndex];
                  });
                  Navigator.pop(context); // Close dialog after selection
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: palette[pIndex],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Button Row...
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close, color: Colors.grey, size: 28.sp),
              ),
            ),

            CustomText(text: "Product Variants", fontSize: 18.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 15.h),

            // Variant List...
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: variants.length,
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildInputContainer(
                        child: TextField(
                          controller: variants[index]['size'],
                          decoration: const InputDecoration(hintText: "Size", border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 2,
                      child: _buildInputContainer(
                        child: TextField(
                          controller: variants[index]['price'],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(hintText: "Price \$", border: InputBorder.none),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () => _pickColor(index),
                      child: Container(
                        height: 45.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: variants[index]['color'],
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Icon(Icons.colorize, color: Colors.white, size: 16.sp),
                      ),
                    ),

                    if (variants.length > 1)
                      IconButton(
                        onPressed: () => setState(() => variants.removeAt(index)),
                        icon: Icon(Icons.delete_outline, color: Colors.redAccent, size: 20.sp),
                      ),
                  ],
                );
              },
            ),



            SizedBox(height: 25.h),

            GestureDetector(
              onTap: _addNewVariant,
              child: Row(
                children: [
                  Icon(Icons.add_circle, color: const Color(0xFF1B3022), size: 28.sp),
                  SizedBox(width: 10.w),
                  CustomText(text: "Add New Variant", fontSize: 16.sp, fontWeight: FontWeight.bold),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // SAVE BUTTON WITH DEBUG PRINT
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("--- 🟢 SAVING DATA TO BACKEND SIMULATION 🟢 ---");

                  for (var variant in variants) {
                    final size = variant['size'].text;
                    final price = variant['price'].text;
                    final colorCode = colorToHex(variant['color']);

                    debugPrint("Variant Found -> Size: $size | Price: $price | Color: $colorCode");
                  }

                  debugPrint("--- 🏁 SAVE COMPLETE 🏁 ---");
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3022),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                ),
                child: CustomText(text: "Save All Variants", color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFCADA9F).withValues(alpha:0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }
}