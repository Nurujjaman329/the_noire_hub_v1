

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../beauticianAddService/data/beauticians_create_service_post_body.dart';
import '../../beauticianAddService/presentation/controller/beauticians_create_service_controller.dart';


// 1. Data model to hold a complete variant group
class VariantSet {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<Map<String, TextEditingController>> subVariants = [
    {'name': TextEditingController(), 'price': TextEditingController()},
  ];

  void addSubVariant() {
    subVariants.add({'name': TextEditingController(), 'price': TextEditingController()});
  }
}

class BeauticiansAddVariantSheet extends StatefulWidget {
  const BeauticiansAddVariantSheet({super.key});

  @override
  State<BeauticiansAddVariantSheet> createState() => _BeauticiansAddVariantSheetState();
}

class _BeauticiansAddVariantSheetState extends State<BeauticiansAddVariantSheet> {
  final controller = Get.find<BeauticiansCreateServiceController>();

  // Maintain a list of VariantSets
  List<VariantSet> variantSets = [VariantSet()];

  void _addNewVariantSet() {
    setState(() {
      variantSets.add(VariantSet());
    });
  }

  // New Logic: Map UI Controllers to the API Models
  void _saveToController() {
    List<ServiceVariantBody> finalVariants = [];

    for (var set in variantSets) {
      if (set.nameController.text.trim().isEmpty) continue;

      List<ServiceSubVariantBody> subVariants = [];
      for (var sub in set.subVariants) {
        String subName = sub['name']!.text.trim();
        if (subName.isNotEmpty) {
          subVariants.add(
            ServiceSubVariantBody(
              name: subName,
              price: double.tryParse(sub['price']!.text.trim()) ?? 0.0,
            ),
          );
        }
      }

      finalVariants.add(
        ServiceVariantBody(
          variantName: set.nameController.text.trim(),
          description: set.descController.text.trim(),
          subVariants: subVariants,
        ),
      );
    }

    // Update the controller and close
    controller.selectedVariants.assignAll(finalVariants);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close, color: Colors.grey.shade600, size: 28.sp),
                ),
              ),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: variantSets.length,
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Divider(color: Colors.grey.shade300, thickness: 1),
                ),
                itemBuilder: (context, setIndex) {
                  return _buildVariantBlock(setIndex);
                },
              ),

              SizedBox(height: 20.h),

              GestureDetector(
                onTap: _addNewVariantSet,
                child: Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.black, size: 32.sp),
                    SizedBox(width: 12.w),
                    CustomText(text: "Add New Variant", fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: _saveToController, // Updated to save logic
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B3022),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                    elevation: 0,
                  ),
                  child: CustomText(text: "Save", color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVariantBlock(int setIndex) {
    final set = variantSets[setIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLargeInput("Variant Name e.g. length", set.nameController),
        SizedBox(height: 12.h),
        _buildLargeInput("Variant Description", set.descController, isLong: true),
        SizedBox(height: 25.h),
        CustomText(text: "Sub-variants", fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0XFF000000)),
        CustomText(
          text: "Services under the main variant name listed above",
          fontSize: 11.sp,
          color: const Color(0x66000000),
          bottom: 15.h,
        ),
        Row(
          children: [
            Expanded(flex: 3, child: CustomText(text: "Name", fontWeight: FontWeight.w600, color: const Color(0XFF000000))),
            Expanded(flex: 2, child: CustomText(text: "Price", fontWeight: FontWeight.w600, color: const Color(0XFF000000))),
          ],
        ),
        SizedBox(height: 10.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: set.subVariants.length,
          separatorBuilder: (_, _) => SizedBox(height: 10.h),
          itemBuilder: (context, subIndex) {
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildSubInput("e.g. Waist Length", set.subVariants[subIndex]['name']!),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  flex: 2,
                  child: _buildSubInput("\$0.00", set.subVariants[subIndex]['price']!),
                ),
                // Added a small remove button for sub-variants for better UX
                if (set.subVariants.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                    onPressed: () => setState(() => set.subVariants.removeAt(subIndex)),
                  )
              ],
            );
          },
        ),
        SizedBox(height: 15.h),
        GestureDetector(
          onTap: () => setState(() => set.addSubVariant()),
          child: Row(
            children: [
              Icon(Icons.add_circle, color: const Color(0xFFB8C994), size: 22.sp),
              SizedBox(width: 8.w),
              CustomText(text: "Add sub-variant", color: const Color(0xFFB8C994), fontWeight: FontWeight.w500),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLargeInput(String hint, TextEditingController controller, {bool isLong = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: const Color(0xFFD5E3B2),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: TextField(
        controller: controller,
        maxLines: isLong ? 3 : 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: const Color(0x4D000000), fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSubInput(String hint, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFD9E8B9), width: 1.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: hint.contains('\$') ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: const Color(0x4D000000), fontSize: 12.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}