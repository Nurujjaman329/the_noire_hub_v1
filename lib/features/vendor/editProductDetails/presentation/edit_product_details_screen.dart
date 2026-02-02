import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import 'package:get/get.dart';


class EditProductDetailsScreen extends StatelessWidget {
  const EditProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Header with Logo (Pinned)
          _buildSliverAppBar(),

          // 2. The Main Content Card that fills the remaining space
          SliverFillRemaining(
            hasScrollBody: false, // Allows the column to take full height
            child: Transform.translate(
              offset: Offset(0, -0.5.r), // The overlap "bite"
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.r),
                    topRight: Radius.circular(50.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25.w, 35.h, 25.w, 25.h), // Adjusted top padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(height: 10.h),
                      Center(
                        child: CustomText(
                          text: "Edit Product",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D3826),
                        ),
                      ),
                      SizedBox(height: 25.h),

                      // 3. Image Section
                      _buildImagePicker(),

                      SizedBox(height: 25.h),

                      // 4. Form Section
                      _buildFieldLabel("Product Name"),
                      _buildInputField(hint: "Ada's Deep Cleanse Avocado Clay Mask"),

                      SizedBox(height: 18.h),
                      _buildFieldLabel("Product Price"),
                      _buildInputField(hint: "\$120"),

                      SizedBox(height: 18.h),
                      _buildFieldLabel("Product Discount Price"),
                      _buildInputField(hint: "12 %"),

                      SizedBox(height: 18.h),
                      _buildFieldLabel("Description (optional)"),
                      _buildInputField(hint: "", isLarge: true),

                      // Use Spacer or Expanded to push button to bottom if space allows
                      const Spacer(),
                      SizedBox(height: 40.h),

                      // 5. Update Button
                      CustomButton(
                        text: "Update Product",
                        onTap: () {
                          // Logic to update product
                        },
                      ),
                      SizedBox(height: 20.h), // Safe area at bottom
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180.h,
      backgroundColor: const Color(0xFF9BB575), // Moss Green to match image exactly
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Center(
          child: CustomNetworkImage(
              imageUrl: AppAssets.appLogo,
              height: 60.h,
              width: 150.w,
              fit: BoxFit.contain
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 20.sp),
        onPressed: () => Get.back(),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildImagePicker() {
    return Container(
      height: 180.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        image: const DecorationImage(
          image: NetworkImage("https://images.pexels.com/photos/3616991/pexels-photo-3616991.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: const BoxDecoration(
            color: Color(0xFF1D3826), // Deep Green Upload Circle
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.file_upload_outlined, color: Colors.white, size: 28.sp),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h, left: 5.w),
      child: CustomText(
        text: label,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1D3826),
      ),
    );
  }

  Widget _buildInputField({required String hint, bool isLarge = false}) {
    return Container(
      height: isLarge ? 120.h : 48.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: isLarge ? 10.h : 0),
      decoration: BoxDecoration(
        color: const Color(0xFF9BB575).withOpacity(0.9), // Moss Green Field
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        maxLines: isLarge ? 6 : 1,
        style: TextStyle(color: Colors.white, fontSize: 13.sp),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}

