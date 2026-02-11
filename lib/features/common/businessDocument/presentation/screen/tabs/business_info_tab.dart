import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/services/cache_service.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/custom_text.dart';
import '../../../data/businessInfo/categoryUpdate/category_update_post_body.dart';
import '../../controller/businessInfo/business_info_controller.dart';


class BusinessInfoTab extends StatelessWidget {
  const BusinessInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final infoController = Get.find<BusinessInfoController>();

    return Obx(() {
      if (infoController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0XFF627E4C),
          ),
        );
      }

      final data = infoController.businessData.value;
      if (data == null) {
        return const Center(child: Text("No Data Found"));
      }

      return SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // 1. Profile Header
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: const Color(0XFF627E4C),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                children: [
                  CustomNetworkImage(
                    imageUrl: "${ApiConstants.baseImageUrl}${CacheService.userImage}",
                    height: 60.r, width: 60.r, boxShape: BoxShape.circle,
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomText(text: data.businessName, color: const Color(0XFFF1F0B2), fontWeight: FontWeight.bold, fontSize: 16.sp),
                            if (data.documentApproved) ...[
                              SizedBox(width: 5.w),
                              Icon(Icons.verified, color: const Color(0XFFF1F0B2), size: 16.sp),
                            ]
                          ],
                        ),
                        CustomText(text: "${data.rating} ★ Rating", color: const Color(0XFFF1F0B2), fontSize: 12.sp, top: 4.h),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: data.documentApproved ? const Color(0XFF1D3826) : Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                          child: CustomText(
                            text: data.documentApproved ? "Verified Account" : "Not Verified",
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0XFFF1F0B2),
                          ),
                        )
                      ],
                    ),
                  ),
                  Icon(Icons.edit_outlined, color: Colors.black, size: 20.sp),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // 2. Contact & Bio Details
            _buildContactTile(Icons.location_on, "Address", "${data.address.city}, ${data.address.country}"),
            _buildContactTile(Icons.phone, "Phone", "+${data.phoneNumber}"),

            // UPDATED: Bio Section using the card tile format
            _buildContactTile(Icons.article_outlined, "Your Bio", data.bio),

            SizedBox(height: 5.h), // Small gap before categories

            // 3. Categories & Subcategories
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    "Categories",
                    onAddTap: () => _showCategorySelectionSheet(), // Function to select new ones
                  ),
                  SizedBox(height: 10.h),
                  Obx(() => infoController.isUpdating.value
                      ? const LinearProgressIndicator()
                      : Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: data.categories.map((cat) => _buildTag(cat.category)).toList(),
                  )),

                  SizedBox(height: 20.h),

                  _buildSectionHeader("SubCategories"), // Usually linked to categories
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: data.categories
                        .expand((cat) => cat.subcategories)
                        .map((sub) => _buildTag(sub))
                        .toList(),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // 4. Quick Facts Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "Quick Facts", fontWeight: FontWeight.bold, fontSize: 16.sp, bottom: 15.h),
                  _buildFactRow("Date Joined", data.joinDate),
                  _buildFactRow("Annual Verification Due", data.annualDocumentApproveDate, valueColor: const Color(0XFF627E4C)),
                  _buildFactRow("No of Products Listed", data.totalProducts.toString()),
                  _buildFactRow("Most Popular Item", data.mostPopularItem, isSmall: true),
                  _buildFactRow("Least Popular Item", data.leastPopularItem, isSmall: true),
                  _buildFactRow("Completed Orders", data.completedOrders.toString(), hideDivider: true),
                ],
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      );
    });

  }


  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Color(0XFF9BB575),
        // color: AppColors.primaryLight.withValues(alpha:0.7),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(text: label, color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w500),
    );
  }




  Widget _buildContactTile(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black, size: 22.sp),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: title, fontWeight: FontWeight.bold, fontSize: 14.sp,color : Color(0XFF000000),),
                CustomText(text: value, color: Color(0xB2000000), fontSize: 12.sp, top: 4.h),
              ],
            ),
          ),
          Icon(Icons.edit_outlined, color : Color(0XFF000000), size: 16.sp),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onAddTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: title, fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.black),
        if (onAddTap != null)
          GestureDetector(
            onTap: onAddTap,
            child: Icon(Icons.add_circle, color: const Color(0XFF627E4C), size: 20.sp),
          ),
      ],
    );
  }

  void _showCategorySelectionSheet() {

    final mockSelection = CategoryUpdatePostBody(
        selectedCategories: [
          SelectedCategory(
              category: "69677549005cd31d7fff3004",
              subcategories: ["6982ec994710a11dade1da92", "6982e935989ee73ffa121cb1"] // Sub IDs
          )
        ]
    );

    Get.defaultDialog(
      title: "Update Categories",
      middleText: "Do you want to save these changes?",
      onConfirm: () {
        Get.back();
       // infoController.updateBusinessCategories(mockSelection);
      },
      textConfirm: "Save",
      confirmTextColor: Colors.white,
      buttonColor: const Color(0XFF627E4C),
    );
  }


  Widget _buildFactRow(String label, String value, {Color? valueColor, bool hideDivider = false, bool isSmall = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: label, color : Color(0XFF000000), fontSize: 12.sp),
              CustomText(
                  text: value,
                  color: valueColor ?? Color(0x80000000),
                  fontSize: isSmall ? 10.sp : 12.sp,
                  fontWeight: FontWeight.w500
              ),
            ],
          ),
        ),
        if (!hideDivider) Divider(color: AppColors.divider, thickness: 1),
      ],
    );
  }


}
