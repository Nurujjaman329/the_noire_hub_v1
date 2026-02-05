import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/storage/local_storage.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../authentication/login/data/login_response_model.dart';
import '../../data/vendor_products_response_model.dart';
import '../controller/vendor_product_controller.dart';

class VendorStoreScreen extends GetView<VendorProductController> {
  const VendorStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pull logged in user info for the store header
    final user = LocalStorage.getUserModel();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.isLoading.value && controller.productList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF707E5F)));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchProducts(),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                _buildHeaderBackground(),
                Column(
                  children: [
                    SizedBox(height: 160.h),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.r),
                          topRight: Radius.circular(50.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          Transform.translate(
                            offset: Offset(0, -60.h),
                            child: _buildFloatingProfileImage(user),
                          ),
                          Transform.translate(
                            offset: Offset(0, -40.h),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                children: [
                                  _buildStoreInfo(user),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15.h),
                                    child: Divider(color: AppColors.geryColor.withOpacity(0.2), thickness: 1),
                                  ),
                                  _buildTextButtonsToggle(),
                                  SizedBox(height: 10.h),

                                  // Group products by category dynamically
                                  if (controller.productList.isEmpty)
                                    _buildEmptyState()
                                  else
                                    _buildDynamicProductList(),

                                  SizedBox(height: 100.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeaderBackground() {
    return SizedBox(
      height: 240.h, // Set the fixed height of your background
      child: Stack(
        children: [
          CustomNetworkImage(
            imageUrl: AppAssets.vendorStoreTop,
            height: 240.h,
            width: double.infinity,
            borderRadius: BorderRadius.zero,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CustomNetworkImage(
              imageUrl: AppAssets.vendorStoreShadow,
              height: 140.h,
              width: 220.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingProfileImage(UserModel? user) {
    return Container(
      padding: EdgeInsets.all(5.r),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: CustomNetworkImage(
        imageUrl: user?.fullProfileImageUrl ?? "",
        height: 110.r,
        width: 110.r,
        boxShape: BoxShape.circle,
      ),
    );
  }

  Widget _buildStoreInfo(UserModel? user) {
    return Column(
      children: [
        CustomText(
          text: user?.businessName ?? "My Shop",
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0XFF1D3826),
        ),
        SizedBox(height: 10.h),
        CustomText(
          text: user?.bio ?? "Welcome to our store.",
          textAlign: TextAlign.center,
          fontSize: 11.sp,
          color: const Color(0x80000000),
          height: 1.4,
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _infoTile("Verified Vendor"),
              _infoDivider(),
              _infoTile(user?.email ?? ""),
              _infoDivider(),
              _infoTile(user?.role.toUpperCase() ?? ""),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicProductList() {
    // Simple logic to show all products or group them if you have categories
    return _buildProductSection("All Products", controller.productList);
  }

  Widget _buildProductSection(String title, List<VendorProductModel> products) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 25.h, bottom: 15.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: title, fontSize: 18.sp, fontWeight: FontWeight.bold),
              GestureDetector(
               // onTap: () => Get.toNamed(RouteConstants.addProduct),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, size: 18.sp, color: const Color(0xFF707E5F)),
                    CustomText(
                      text: "Add Product",
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF707E5F),
                      left: 5.w,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.78,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.h,
          ),
          itemBuilder: (context, index) => _buildProductCard(products[index]),
        ),
      ],
    );
  }

  Widget _buildProductCard(VendorProductModel product) {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteConstants.vendorProductDetailScreen, arguments: product.id),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0XFFF0F0EC),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: CustomNetworkImage(
                    imageUrl: "${ApiConstants.baseImageUrl}${product.image}",
                    width: double.infinity,
                    fit: BoxFit.cover, height: 70,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: product.name,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: product.category,
                    fontSize: 9.sp,
                    color: const Color(0x99000000),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "\$${product.price.toStringAsFixed(2)}",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      _buildProductMenu(product),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductMenu(VendorProductModel product) {
    return PopupMenuButton<String>(
      color: const Color(0XFF627E4C),
      icon: Icon(Icons.more_vert, size: 18.sp, color: AppColors.geryColor),
      onSelected: (value) {
        if (value == 'edit') {
          Get.toNamed(RouteConstants.editProductDetailScreen, arguments: product);
        } else if (value == 'delete') {
          // Add delete confirmation dialog
        }
      },
      itemBuilder: (context) => [
        _buildMenuItem('edit', Icons.edit, "Edit", const Color(0XFFF1F0B2)),
        _buildMenuItem('delete', Icons.delete, "Delete", Colors.red),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(String value, IconData icon, String text, Color color) {
    return PopupMenuItem(
      value: value,
      height: 35.h,
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 8.w),
          CustomText(text: text, fontSize: 12.sp, color: color),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 50.h),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 50.sp, color: AppColors.geryColor),
            SizedBox(height: 10.h),
            CustomText(text: "No products added yet.", color: AppColors.geryColor),
          ],
        ),
      ),
    );
  }

  // Re-used Helpers
  Widget _infoTile(String text) => CustomText(text: text, fontSize: 9.sp, color: const Color(0XFFB5B475), fontWeight: FontWeight.w500);
  Widget _infoDivider() => Padding(padding: EdgeInsets.symmetric(horizontal: 8.w), child: CustomText(text: "|", fontSize: 10.sp, color: AppColors.geryColor.withOpacity(0.5)));

  Widget _buildTextButtonsToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(text: "Product Inventory", color: const Color(0XFFB5B475), fontSize: 14.sp, fontWeight: FontWeight.bold),
        CustomText(text: "Preview Store", color: const Color(0XFFB5B475), fontSize: 14.sp, fontWeight: FontWeight.bold),
      ],
    );
  }
}