import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_noire_hub_v1/core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../data/beautician_service_update_post_body.dart';
import '../controller/beauticians_update_service_controller.dart';
import 'edit_variant_set.dart';


class BeauticiansEditVariantSheet extends StatefulWidget {
  const BeauticiansEditVariantSheet({super.key});

  @override
  State<BeauticiansEditVariantSheet> createState() => _BeauticiansEditVariantSheetState();
}

class _BeauticiansEditVariantSheetState extends State<BeauticiansEditVariantSheet> {
  final controller = Get.find<BeauticiansUpdateServiceController>();
  List<EditVariantSet> editSets = [];

  @override
  void initState() {
    super.initState();
    // Initialize with existing data from controller
    editSets = controller.selectedVariants.map((v) {
      return EditVariantSet(
        id: v.id,
        name: v.variantName,
        desc: v.description,
        existingSubs: v.subVariants.map((sv) => {
          'name': TextEditingController(text: sv.name),
          'price': TextEditingController(text: sv.price.toString()),
        }).toList(),
      );
    }).toList();

    if (editSets.isEmpty) {
      editSets.add(EditVariantSet(name: "", desc: "", existingSubs: [])..addSubVariant());
    }
  }

  void _saveEdits() {
    List<ServiceVariantUpdateBody> updatedList = [];
    for (var set in editSets) {
      if (set.nameController.text.trim().isEmpty) continue;

      // Determine if this variant should send only ID or full data
      // - Existing variant (has ID) + user opened edit sheet = send full data (they might have modified it)
      // - New variant (no ID) = send full data
      bool sendOnlyId = false; // Always send full data when coming from edit sheet

      updatedList.add(
        ServiceVariantUpdateBody(
          id: set.id,
          variantName: set.nameController.text.trim(),
          description: set.descController.text.trim(),
          subVariants: set.subVariants
              .where((s) => s['name']!.text.isNotEmpty)
              .map((s) => ServiceSubVariantUpdateBody(
            name: s['name']!.text.trim(),
            price: double.tryParse(s['price']!.text.trim()) ?? 0.0,
          ))
              .toList(),
          sendOnlyId: sendOnlyId,
        ),
      );
    }
    controller.selectedVariants.assignAll(updatedList);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
      child: Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.8), // Prevent overflow
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(text: "Edit Variants", fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1D3826)),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, color: Colors.grey, size: 24.sp),
                  ),
                ],
              ),
              const Divider(color: Color(0xFF1D3826), thickness: 0.5),
              SizedBox(height: 10.h),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: editSets.length,
                separatorBuilder: (_, _) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: const Divider(color: Color(0xFFCADA9F)),
                ),
                itemBuilder: (context, index) => _buildEditBlock(index),
              ),

              SizedBox(height: 20.h),
              _buildAddVariantBtn(),
              SizedBox(height: 30.h),
              CustomButton(text: "Apply Changes", onTap: _saveEdits),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditBlock(int index) {
    final set = editSets[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: "Main Variant #${index + 1}", fontWeight: FontWeight.bold, color: const Color(0xFF1D3826)),
            if (editSets.length > 1)
              GestureDetector(
                onTap: () => setState(() => editSets.removeAt(index)),
                child: const Icon(Icons.delete_forever, color: Colors.redAccent),
              )
          ],
        ),
        SizedBox(height: 12.h),
        _buildInputField("e.g. Length or Color", set.nameController),
        SizedBox(height: 10.h),
        _buildInputField("Description", set.descController, isLong: true),
        SizedBox(height: 20.h),

        CustomText(text: "Sub-options", fontSize: 14.sp, fontWeight: FontWeight.w600),
        SizedBox(height: 10.h),

        ...set.subVariants.asMap().entries.map((entry) {
          int subIdx = entry.key;
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              children: [
                Expanded(flex: 3, child: _buildSubInputField("Name", set.subVariants[subIdx]['name']!)),
                SizedBox(width: 10.w),
                Expanded(flex: 2, child: _buildSubInputField("\$ 0.00", set.subVariants[subIdx]['price']!, isNum: true)),
                if (set.subVariants.length > 1)
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.redAccent.withValues(alpha:0.7), size: 20.sp),
                    onPressed: () => setState(() => set.subVariants.removeAt(subIdx)),
                  )
              ],
            ),
          );
        }),

        GestureDetector(
          onTap: () => setState(() => set.addSubVariant()),
          child: Row(
            children: [
              Icon(Icons.add_circle_outline, color: const Color(0xFFB5B475), size: 18.sp),
              SizedBox(width: 5.w),
              CustomText(text: "Add sub-option", color: const Color(0xFFB5B475), fontSize: 13.sp, fontWeight: FontWeight.w500),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(String hint, TextEditingController ctr, {bool isLong = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFCADA9F).withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF1D3826).withValues(alpha:0.3)),
      ),
      child: TextField(
        controller: ctr,
        maxLines: isLong ? 2 : 1,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none, hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey)),
      ),
    );
  }

  Widget _buildSubInputField(String hint, TextEditingController ctr, {bool isNum = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFF1D3826).withValues(alpha:0.5)),
      ),
      child: TextField(
        controller: ctr,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        style: TextStyle(fontSize: 13.sp),
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey.withValues(alpha:0.6)),
        ),
      ),
    );
  }

  Widget _buildAddVariantBtn() {
    return GestureDetector(
      onTap: () => setState(() => editSets.add(EditVariantSet(name: "", desc: "", existingSubs: [])..addSubVariant())),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1D3826), style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle, color: const Color(0xFF1D3826), size: 22.sp),
            SizedBox(width: 10.w),
            CustomText(text: "Add Another Main Variant", fontWeight: FontWeight.bold, color: const Color(0xFF1D3826)),
          ],
        ),
      ),
    );
  }
}