import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/services/cache_service.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/widgets/custom_network_image.dart';
import '../../../../../../core/widgets/custom_text.dart';
import '../../../../category/presentation/controller/category_controller.dart';
import '../../../../subCategories/presentation/controller/sub_categories_controller.dart';
import '../../../data/businessInfo/categoryUpdate/category_update_post_body.dart';
import '../../controller/businessInfo/business_info_controller.dart';


class BusinessInfoTab extends StatelessWidget {
  const BusinessInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final infoController = Get.find<BusinessInfoController>();

    return Obx(() {
      if (infoController.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: Color(0XFF627E4C)));
      }

      final data = infoController.businessData.value;
      if (data == null) return const Center(child: Text("No Data Found"));

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
                    imageUrl: "${ApiConstants.baseImageUrl}${data.shopImage}",
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
            _buildContactTile(Icons.article_outlined, "Your Bio", data.bio),

            SizedBox(height: 5.h),

            // 3. Categories & Subcategories Section
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
                    onAddTap: () => _showCategorySelectionSheet(),
                  ),
                  SizedBox(height: 10.h),
                  Obx(() => infoController.isUpdating.value
                      ? const LinearProgressIndicator()
                      : Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: data.categories
                        .map((cat) => _buildTag(cat.category.name)) // Use .name
                        .toList(),
                  )),

                  SizedBox(height: 20.h),

                  _buildSectionHeader("SubCategories"),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: data.categories
                        .expand((cat) => cat.subcategories)
                        .map((sub) => _buildTag(sub.name)) // Use .name
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

  // --- Category Selection Sheet Implementation ---

// --- Category Selection Sheet Implementation ---
  void _showCategorySelectionSheet() {
    final infoController = Get.find<BusinessInfoController>();
    final catController = Get.find<CategoryController>();
    final subCatController = Get.find<SubCategoryController>();

    // 1. Determine the category type based on role once
    final String userType = CacheService.role;
    final String activeCategoryType = userType == "vendor" ? "product" : "service";

    final RxMap<String, List<String>> tempSelection = <String, List<String>>{}.obs;

    final existingData = infoController.businessData.value;
    if (existingData != null) {
      for (var catEntry in existingData.categories) {
        tempSelection[catEntry.category.id] =
            catEntry.subcategories.map((s) => s.id).toList();
      }
    }

    // Use the dynamic category type for the main list
    catController.loadCategories(page: 1,);

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      Container(
        height: Get.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            _buildSheetHeader(),
            Expanded(
              child: Obx(() {
                if (catController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: Color(0XFF627E4C)));
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  itemCount: catController.categories.length,
                  itemBuilder: (context, index) {
                    final category = catController.categories[index];

                    return Obx(() {
                      final isSelected = tempSelection.containsKey(category.id);

                      return Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          key: PageStorageKey(category.id),
                          maintainState: true,
                          onExpansionChanged: (expanded) {
                            if (expanded) {
                              // 2. USE activeCategoryType HERE
                              subCatController.fetchSubCategories(
                                  categoryId: category.id,
                                  categoryType: activeCategoryType
                              );
                            }
                          },
                          leading: Checkbox(
                            activeColor: const Color(0XFF627E4C),
                            value: isSelected,
                            onChanged: (val) {
                              if (val == true) {
                                tempSelection[category.id] = [];
                                // 3. AND USE activeCategoryType HERE
                                subCatController.fetchSubCategories(
                                    categoryId: category.id,
                                    categoryType: activeCategoryType
                                );
                              } else {
                                tempSelection.remove(category.id);
                              }
                            },
                          ),
                          title: CustomText(
                            text: category.name,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0XFF627E4C) : Colors.black,
                          ),
                          children: [
                            _buildSubCategoryGrid(category.id, tempSelection, subCatController)
                          ],
                        ),
                      );
                    });
                  },
                );
              }),
            ),

            // Save Changes Button...
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Obx(() => CustomButton(
                text: "Save Changes",
                loading: infoController.isUpdating.value,
                onTap: () {
                  final body = CategoryUpdatePostBody(
                      selectedCategories: tempSelection.entries.map((e) =>
                          SelectedCategory(category: e.key, subcategories: e.value)
                      ).toList()
                  );
                  infoController.updateBusinessCategories(body);
                  Get.back();
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  // SubCategory Grid logic
  Widget _buildSubCategoryGrid(String parentId, RxMap<String, List<String>> selection, SubCategoryController subController) {
    return Obx(() {
      final subs = subController.subCategories.where((s) => s.category.id == parentId).toList();

      if (subController.isLoading.value && subController.selectedCategoryId == parentId) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: LinearProgressIndicator(color: Color(0XFF627E4C)),
        );
      }

      return Container(
        padding: EdgeInsets.only(left: 50.w, right: 15.w, bottom: 15.h),
        width: double.infinity,
        child: Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: subs.map((sub) {
            final isSubSelected = selection[parentId]?.contains(sub.id) ?? false;
            return FilterChip(
              label: Text(sub.name, style: TextStyle(fontSize: 10.sp)),
              selected: isSubSelected,
              selectedColor: const Color(0XFFCADA9F),
              checkmarkColor: const Color(0XFF627E4C),
              onSelected: (val) {
                if (!selection.containsKey(parentId)) selection[parentId] = [];

                var currentList = List<String>.from(selection[parentId]!);
                if (val) {
                  currentList.add(sub.id);
                } else {
                  currentList.remove(sub.id);
                }
                selection[parentId] = currentList;
              },
            );
          }).toList(),
        ),
      );
    });
  }


  Widget _buildSheetHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: "Edit Categories", fontSize: 18.sp, fontWeight: FontWeight.bold),
          IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
        ],
      ),
    );
  }

  // --- Existing Helper Widgets ---

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0XFF9BB575),
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
                CustomText(text: title, fontWeight: FontWeight.bold, fontSize: 14.sp),
                CustomText(text: value, color: Colors.black54, fontSize: 12.sp, top: 4.h),
              ],
            ),
          ),
          Icon(Icons.edit_outlined, color: Colors.black, size: 16.sp),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onAddTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: title, fontWeight: FontWeight.bold, fontSize: 14.sp),
        if (onAddTap != null)
          GestureDetector(
            onTap: onAddTap,
            child: Icon(Icons.add_circle, color: const Color(0XFF627E4C), size: 20.sp),
          ),
      ],
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
              CustomText(text: label, color: Colors.black, fontSize: 12.sp),
              CustomText(
                  text: value,
                  color: valueColor ?? Colors.black54,
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