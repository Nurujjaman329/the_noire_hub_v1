import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../authentication/login/data/login_response_model.dart';
import '../../../vendorAddVariant/vendor_add_variant_sheet.dart';



class ProductEntry {
  String? subCategory;
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  ProductEntry({this.subCategory});
}

class VendorAddProductScreen extends StatefulWidget {
  const VendorAddProductScreen({super.key});

  @override
  State<VendorAddProductScreen> createState() => _VendorAddProductScreenState();
}

class _VendorAddProductScreenState extends State<VendorAddProductScreen> {
  String selectedCategory = "Hair";
  List<ProductEntry> productList = [ProductEntry()];
  UserModel? user;

  // Inventory Categories for Physical Goods
  final Map<String, List<String>> categoryData = {
    "Hair": ["Shampoo", "Extensions", "Wigs", "Conditioner", "Oils"],
    "Make Up": ["Lipstick", "Foundation", "Brushes", "Eyeliner"],
    "Nails": ["Polish", "Acrylic", "Gel", "Nail Art"],
    "Hair Removal": ["Wax", "Lasers", "Creams", "Razors"],
  };

  String get businessName => user?.businessName ?? "My Shop";

  @override
  void initState() {
    super.initState();
    user = LocalStorage.getUserModel();
  }

  @override
  Widget build(BuildContext context) {
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
                        text: businessName,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    _buildSectionTitle(
                        "Product Category",
                        "Select all types of products you sell in your shop"
                    ),
                    _buildSpecialtiesList(),
                    SizedBox(height: 30.h),

                    // List of Product Entry Sections
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: productList.length,
                      separatorBuilder: (context, index) => SizedBox(height: 30.h),
                      itemBuilder: (context, index) => _buildAddProductSection(index),
                    ),

                    SizedBox(height: 40.h),
                    _buildFooter(),
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

  Widget _buildFooter() {
    return CustomButton(
      onTap: () {
        debugPrint("Vendor Saving Products...");
        Get.snackbar(
          "Success",
          "Products saved to your shop!",
          backgroundColor: AppColors.secondaryVariant,
          colorText: Colors.white,
        );
        Get.back();
      },
      text: "Save Products",
    );
  }

  Widget _buildSpecialtiesList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categoryData.keys.map((cat) {
          bool isSelected = selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() {
              selectedCategory = cat;
              for (var product in productList) {
                product.subCategory = null;
              }
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 100.w,
              height: 110.h,
              margin: EdgeInsets.only(right: 15.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondaryVariant : AppColors.primary,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.inventory_2_outlined,
                    color: isSelected ? Colors.white : AppColors.background,
                    size: 30.sp,
                  ),
                  CustomText(
                      text: cat,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      top: 8.h
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddProductSection(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
                text: index == 0 ? "Add Product" : "Product #${index + 1}",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.background
            ),
            SizedBox(width: 140.w, child: _buildDynamicDropdown(index)),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(15.r),
                    decoration: BoxDecoration(
                      color: const Color(0XFFCADA9F),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      children: [
                        _buildSmallInputRow("Product Name", "\$ 0.00"),
                        SizedBox(height: 25.h),
                        const Icon(Icons.add_a_photo_outlined, size: 35, color: Color(0x4D000000)),
                        CustomText(text: "Tap to add photos", fontSize: 11.sp, color: const Color(0x4D000000), top: 8.h),
                        SizedBox(height: 25.h),
                        _buildVariantLink(),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: const Color(0XFFCADA9F),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: CustomText(text: "Product Description", color: const Color(0x4D000000), fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  GestureDetector(
                    onTap: () => setState(() => productList.add(ProductEntry())),
                    child: Column(
                      children: [
                        Icon(Icons.add_circle_outline, color: AppColors.secondaryVariant, size: 35.sp),
                        CustomText(
                          text: "Add Another\nProduct",
                          textAlign: TextAlign.center,
                          fontSize: 9.sp,
                          color: AppColors.geryColor,
                          top: 5.h,
                        ),
                      ],
                    ),
                  ),
                  if (index > 0) ...[
                    SizedBox(height: 20.h),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red.withOpacity(0.5)),
                      onPressed: () => setState(() => productList.removeAt(index)),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDynamicDropdown(int index) {
    List<String> subCategories = categoryData[selectedCategory] ?? [];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.primary),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: productList[index].subCategory,
          hint: CustomText(text: "Subcategory", fontSize: 11.sp, color: AppColors.background),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.background, size: 16.sp),
          items: subCategories.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: CustomText(text: value, fontSize: 11.sp, color: AppColors.background),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              productList[index].subCategory = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildVariantLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: "0 photos added", fontSize: 10.sp, color: const Color(0x4D000000)),
        GestureDetector(
          onTap: () => Get.bottomSheet(
            const VendorAddVariantSheet(),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0x4D000000),
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: CustomText(
              text: "+ Add Variants",
              fontSize: 10.sp,
              color: AppColors.secondaryVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Common UI Helpers (Simplified)
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
        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 20.sp),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: title, fontSize: 16.sp, fontWeight: FontWeight.bold, color: const Color(0XFF1D3826)),
        CustomText(text: sub, fontSize: 11.sp, color: const Color(0XFFB5B475)),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _buildSmallInputRow(String hint, String price) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      CustomText(text: hint, color: const Color(0x4D000000), fontSize: 13.sp),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10.r)),
        child: CustomText(text: price, fontSize: 12.sp, fontWeight: FontWeight.bold),
      )
    ]);
  }
}