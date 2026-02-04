
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/extensions/string_extensions.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../authentication/registration/data/registration_post_body_model.dart';
import '../../../../authentication/registration/presentation/controller/registration_controller.dart';
import '../../../../common/category/presentation/controller/category_controller.dart';
import '../../../../common/subCategories/presentation/controller/sub_categories_controller.dart';


class StoreSetupScreen extends GetView<RegistrationController> {
  const StoreSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catCtrl = Get.find<CategoryController>();
    final subCtrl = Get.find<SubCategoryController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      catCtrl.loadCategories(categoryType: controller.userRole.value);
    });

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.r),
                      topRight: Radius.circular(50.r))),
              child: Padding(
                padding: EdgeInsets.all(25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: CustomText(
                            text: controller.businessNameController.text.isEmpty
                                ? "Your Shop"
                                : controller.businessNameController.text,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0XFF1D3826))),

                    _buildSectionTitle("Add Business Address", "Set your primary location"),

                    // --- MAP SEARCH FIELD ---
                    CustomTextField(
                      controller: controller.searchController, // Using mixin controller
                      hintText: "Search address...",
                      prefixIcon: Icons.location_on_outlined,
                      onChanged: (val) => controller.onSearchChanged(val),
                    ),

                    // --- SEARCH SUGGESTIONS OVERLAY ---
                    Obx(() => controller.placePredictions.isNotEmpty
                        ? Container(
                      constraints: BoxConstraints(maxHeight: 200.h),
                      margin: EdgeInsets.only(top: 5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: controller.placePredictions.length,
                        itemBuilder: (context, index) {
                          final prediction = controller.placePredictions[index];
                          return ListTile(
                            dense: true,
                            title: Text(prediction['description'] ?? "",
                                style: TextStyle(fontSize: 12.sp)),
                            onTap: () async {
                              await controller.selectPrediction(prediction);
                              // Set the address in the main controller
                              controller.addAddress(
                                controller.selectedCountry.value,
                                controller.selectedCity.value,
                                controller.selectedLatLng.value.latitude,
                                controller.selectedLatLng.value.longitude,
                              );
                            },
                          );
                        },
                      ),
                    )
                        : const SizedBox.shrink()),

                    _buildSectionTitle("Category", "Select primary industry"),
                    _buildDynamicCategories(catCtrl, subCtrl),

                    _buildSectionTitle("Choose Subcategories", "Select your specifics"),
                    _buildDynamicSubCategories(subCtrl),

                    _buildSectionTitle("Bio", "Tell buyers about your store"),
                    CustomTextField(
                        controller: controller.bioController,
                        hintText: "Bio description",
                        maxLines: 4),

                    SizedBox(height: 40.h),

                    Obx(() => CustomButton(
                      text: "Create Account",
                      loading: controller.isLoading.value,
                      onTap: () {
                        // Safety check: if user typed but didn't click prediction, we use what we have
                        if (controller.addresses.isEmpty && controller.selectedLatLng.value != null) {
                          controller.addAddress(
                            controller.selectedCountry.value,
                            controller.selectedCity.value,
                            controller.selectedLatLng.value.latitude,
                            controller.selectedLatLng.value.longitude,
                          );
                        }
                        controller.register();
                      },
                    )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicCategories(CategoryController catCtrl, SubCategoryController subCtrl) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: catCtrl.categories.map((cat) {
          bool isSelected = controller.selectedCategories.any((c) => c.category == cat.id);
          return GestureDetector(
            onTap: () {
              controller.selectedCategories.assignAll([
                SelectedCategoryRequest(category: cat.id, subcategories: [])
              ]);
              subCtrl.fetchSubCategories(categoryId: cat.id);
            },
            child: _specialtyCard(cat.name, cat.image, isSelected),
          );
        }).toList(),
      ),
    ));
  }

  Widget _buildDynamicSubCategories(SubCategoryController subCtrl) {
    return Obx(() {
      if (subCtrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: Color(0XFFB5B475)));
      }

      if (subCtrl.subCategories.isEmpty) {
        return CustomText(
          text: "Select a category first to see subcategories",
          fontSize: 12.sp,
          color: Colors.grey,
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: subCtrl.subCategories.map((sub) {
            bool isSelected = controller.selectedCategories.isNotEmpty &&
                controller.selectedCategories.first.subcategories.contains(sub.id);

            return GestureDetector(
              onTap: () {
                if (controller.selectedCategories.isEmpty) return;
                var currentSubKeys = controller.selectedCategories.first.subcategories;
                if (isSelected) {
                  currentSubKeys.remove(sub.id);
                } else {
                  currentSubKeys.add(sub.id);
                }
                controller.selectedCategories.refresh();
              },
              child: _subcategoryCard(sub.name, sub.image, isSelected),
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _subcategoryCard(String title, String imageUrl, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 90.w,
      margin: EdgeInsets.only(right: 12.w, bottom: 5.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0XFF1D3826) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? Colors.transparent : const Color(0XFFB5B475).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: const Color(0XFF1D3826).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ] : [],
      ),
      child: Column(
        children: [
          // Subcategory Image/Icon
          CustomNetworkImage(
            imageUrl: imageUrl.toFullUrl,
            height: 35.h,
            width: 35.h,
            // Add a color filter if selected to make the icon pop
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : const Color(0XFF1D3826),
            ),
          ),
        ],
      ),
    );
  }


  Widget _specialtyCard(String title, String imageUrl, bool isSelected) {
    return Container(
      width: 110.w,
      height: 120.h,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        color: isSelected ? Color(0XFFB5B475) : Color(0XFFF1F0B2),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: isSelected ? Colors.transparent : AppColors.primary),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomNetworkImage(imageUrl: imageUrl.toFullUrl, height: 50.h, width: 50.h),
          CustomText(
              text: title,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.textPrimary,
              top: 8.h
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180.h,
      backgroundColor: AppColors.primaryDark,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          background: Center(
              child: CustomNetworkImage(
                  imageUrl: AppAssets.appLogo,
                  height: 60.h,
                  width: 150.w,
                  fit: BoxFit.contain
              )
          )
      ),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back()
      ),
    );
  }

  Widget _buildSectionTitle(String title, String sub) {
    return Padding(
        padding: EdgeInsets.only(top: 15.h, bottom: 8.h),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: title, fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0XFF1D3826)),
              CustomText(text: sub, fontSize: 11.sp, color: const Color(0x4D000000)),
            ]
        )
    );
  }
}