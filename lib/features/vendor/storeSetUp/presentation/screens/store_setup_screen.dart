
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/accountController/account_controller.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class StoreSetupScreen extends StatefulWidget {
  const StoreSetupScreen({super.key});

  @override
  State<StoreSetupScreen> createState() => _StoreSetupScreenState();
}

class _StoreSetupScreenState extends State<StoreSetupScreen> {
  // Controllers for the CustomTextFields
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  String selectedCategory = "Hair";
  List<String> selectedSubCategories = [];

  final Map<String, List<String>> categoryData = {
    "Hair": ["Shampoo", "Extensions", "Wigs", "Conditioner", "Oils"],
    "Make Up": ["Lipstick", "Foundation", "Brushes", "Eyeliner"],
    "Nails": ["Polish", "Acrylic", "Gel", "Nail Art"],
    "Hair Removal": ["Wax", "Lasers", "Creams", "Razors"],
  };

  final AccountController accountController = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {

    final String typeLabel = accountController.isVendor ? "Product" : "Service";
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
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
                padding: EdgeInsets.all(25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomText(
                        text: "Ada's Body Shop",
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        // color: AppColors.background,
                        color: Color(0XFF1D3826),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // --- ADDRESS SECTION ---
                    _buildSectionTitle("Add Business Address", "Add the exact location of your business"),
                    CustomTextField(
                      controller: addressController,
                      hintText: "72 Poplar Ave NW",
                      prefixIcon: Icons.location_on_outlined,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomText(text: "Same as order fulfillment origin?", fontSize: 10.sp, color: AppColors.background),
                        Transform.scale(
                          scale: 0.8,
                          child: Checkbox(value: false, onChanged: (v) {}, activeColor: AppColors.secondaryVariant),
                        ),
                      ],
                    ),

                    _buildSectionTitle("$typeLabel Category", "Select your primary business type"),
                    _buildSpecialtiesList(),

                    SizedBox(height: 25.h),

                    _buildSectionTitle("Choose Subcategories", "Select specific items you sell in $selectedCategory"),
                    _buildSubCategoryGrid(),

                    SizedBox(height: 25.h),

                    // --- BIO SECTION ---
                    _buildSectionTitle("Bio", "Tell potential buyers a little bit about your store"),
                    CustomTextField(
                      controller: bioController,
                      hintText: "Tell potential buyers a little bit about your store",
                      maxLines: 4, // Makes it a large text area
                    ),

                    SizedBox(height: 40.h),

                    _buildFooterButtons(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SubCategory Chips ---
  Widget _buildSubCategoryGrid() {
    List<String> subCats = categoryData[selectedCategory] ?? [];
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: subCats.map((name) {
        bool isSelected = selectedSubCategories.contains(name);
        return GestureDetector(
          onTap: () {
            setState(() {
              isSelected ? selectedSubCategories.remove(name) : selectedSubCategories.add(name);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondaryVariant : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: isSelected ? AppColors.secondaryVariant : AppColors.primary),
            ),
            child: CustomText(
              text: name,
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- Main Category Cards ---
  Widget _buildSpecialtiesList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categoryData.keys.map((cat) {
          return _specialtyCard(
              cat,
              "https://cdn-icons-png.flaticon.com/512/1940/1940922.png", // Replace with real icons
              selectedCategory == cat ? AppColors.secondaryVariant : AppColors.primary,
              selectedCategory == cat ? Colors.white : AppColors.textPrimary
          );
        }).toList(),
      ),
    );
  }

  Widget _specialtyCard(String title, String imageUrl, Color bg, Color textColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
          selectedSubCategories.clear();
        });
      },
      child: Container(
        width: 110.w,
        height: 120.h,
        margin: EdgeInsets.only(right: 15.w),
        decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: bg == AppColors.secondaryVariant ? [
              BoxShadow(color: bg.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
            ] : null
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50.h, child: Image.network(imageUrl, fit: BoxFit.contain)),
            CustomText(text: title, fontSize: 12.sp, fontWeight: FontWeight.bold, color: textColor, top: 8.h),
          ],
        ),
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
          child: CustomNetworkImage(imageUrl: AppAssets.appLogo, height: 60.h, width: 150.w, fit: BoxFit.contain),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildFooterButtons() {
    return CustomButton(
        text: "Create Account",
        textColor: Colors.white,
        onTap: () => Get.toNamed(RouteConstants.otpVerifyScreen)
      // onTap: () => Get.toNamed(RouteConstants.vendorMainContainer)
    );
  }

  Widget _buildSectionTitle(String title, String sub) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: title, fontSize: 18.sp, fontWeight: FontWeight.bold,  color: Color(0XFF1D3826),),
          CustomText(text: sub, fontSize: 11.sp, color: Color(0x4D000000),),
        ],
      ),
    );
  }
}