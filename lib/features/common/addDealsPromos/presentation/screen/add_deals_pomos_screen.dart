import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';


class AddDealsPomosScreen extends StatelessWidget {
  const AddDealsPomosScreen({super.key});

  // Provided static image link
  static String vendorStoreTop = AppAssets.registration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Top Image Header with Back Button
            Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: vendorStoreTop,
                  height: 250.h,
                  width: double.infinity,
                ),
                Positioned(
                  top: 40.h,
                  left: 20.w,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
                    ),
                  ),
                ),
              ],
            ),

           Padding(
             padding:  EdgeInsets.symmetric(horizontal: 23.w,vertical: 8.h),
             child: CustomButton(
                 onTap: () {
                   showPromoSheet(context, isEdit: false);
                 },
                 text: "Add Promo Code"
             ),
           ),

            // 4. Available Promos List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Available Promos & Deals",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: 15.h),
                  _buildWhiteCard(
                    child: Column(
                      children: [
                        _promoTile("20% Discounts", "52 Stores", "10/20/2025",context),
                        _promoTile("10% Discounts", "73 Stores", "10/20/2025",context),
                        _promoTile("10% Discounts", "73 Stores", "10/20/2025",context, isLast: true),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteCard({required Widget child, EdgeInsetsGeometry? margin}) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: child,
    );
  }

// Updated Promo Tile with Round Button
  Widget _promoTile(String title, String sub, String date,BuildContext context, {bool isLast = false}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              CustomText(
                text: title,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF1D3826),
              ),
              SizedBox(width: 5.w),
              CustomText(
                text: "($sub)",
                fontSize: 11.sp,
                color: Colors.grey,
              ),
            ],
          ),
          subtitle: CustomText(
            text: "Available till $date",
            fontSize: 12.sp,
            color: Colors.grey,
          ),
          // FIXED: Wrap Row in a SizedBox and use MainAxisSize.min
          trailing: SizedBox(
            width: 85.w, // Adjusted width to fit two CircleAvatars
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit Button
                GestureDetector(
                  onTap: () {
                    showPromoSheet(context, isEdit: true);
                  },
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: const Color(0XFFF1F0B2),
                    child: Icon(Icons.edit, color: const Color(0XFF1D3826), size: 16.sp),
                  ),
                ),
                SizedBox(width: 8.w),
                // Delete Button
                GestureDetector(
                  onTap: () {
                    // Add Delete Logic
                  },
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: const Color(0XFFF1F0B2),
                    child: Icon(Icons.delete, color: const Color(0XFF1D3826), size: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(color: AppColors.divider),
      ],
    );
  }


  void showPromoSheet(BuildContext context, {bool isEdit = false}) {
    // Controller to handle the date text
    final TextEditingController dateController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF9F9F4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      builder: (context) {
        // StatefulBuilder allows the sheet to update when a date is selected
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {

            // Function to show the Date Picker
            Future<void> selectDate() async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(), // Vendors can't pick past dates
                lastDate: DateTime(2101),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0XFF1D3826), // Header background color
                        onPrimary: Colors.white,    // Header text color
                        onSurface: Color(0XFF1D3826), // Body text color
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setModalState(() {
                  // Formatting the date (e.g., 2026-01-31)
                  dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                });
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(25.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomText(
                        text: isEdit ? "Edit Promo" : "Create Promo",
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 25.h),

                    _buildSheetLabel("Promo Title"),
                    _buildSheetInputField(hint: "Summer Sale"),

                    SizedBox(height: 15.h),

                    _buildSheetLabel("Offer Price %"),
                    _buildSheetInputField(hint: "15%"),

                    SizedBox(height: 15.h),

                    _buildSheetLabel("Exp. Date"),
                    // Wrapped in GestureDetector to trigger calendar
                    GestureDetector(
                      onTap: selectDate,
                      child: AbsorbPointer( // Prevents keyboard from opening
                        child: _buildSheetInputField(
                          hint: "Select Date",
                          controller: dateController, // Pass the controller
                          suffixIcon: Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.grey,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 15.h),

                    _buildSheetLabel("Description (optional)"),
                    _buildSheetInputField(hint: "Enter details...", isLarge: true),

                    SizedBox(height: 30.h),

                    CustomButton(
                      text: isEdit ? "Update" : "Create Offer",
                      onTap: () {
                        // Access dateController.text for the value
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// --- Helper Widgets for Bottom Sheet ---

  Widget _buildSheetLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 2.w),
      child: CustomText(
        text: label,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildSheetInputField({required String hint, bool isLarge = false, Widget? suffixIcon, TextEditingController? controller}) {
    return Container(
        height: isLarge ? 100.h : 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: TextField(
          controller: controller,
          maxLines: isLarge ? 5 : 1,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: isLarge ? 10.h : 0),
            hintText: hint,
            suffixIcon: suffixIcon,
          ),
        )
    );
    }



}
