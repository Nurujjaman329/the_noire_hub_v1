import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';


class VendorStoreListScreen extends StatelessWidget {
  const VendorStoreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// 🔹 TOP IMAGE SECTION
          Stack(
            children: [
              Image.asset(
                AppAssets.vendorStore,
                height: 280.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 50.h,
                left: 20.w,
                child: GestureDetector(
                  onTap: () => Get.back(), // GetX back navigation
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),

          /// 🔹 CURVED CARD + CONTENT
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -50.h), // 🔥 overlap image
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                    EdgeInsets.only(top: 30.h, bottom: 40.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Vendor Name
                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 20.w),
                          child: CustomText(
                            text: "Skie Homemade Care Products",
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        /// Search Bar
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 15.h,
                          ),
                          child: Container(
                            height: 50.h,
                            padding:
                            EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                              color: const Color(0x4DD6D5C9),
                              borderRadius:
                              BorderRadius.circular(30.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search,
                                    color: Color(0XFF000000), size: 20.sp),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText:
                                      "Search for masks, cleansers...",
                                      hintStyle: TextStyle(
                                        fontSize: 12.sp,
                                        color: Color(0XFF000000),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        _buildSectionHeader("Popular"),
                        _buildHorizontalProductList(),

                        _buildSectionHeader("Our Specials"),
                        _buildHorizontalProductList(),

                        _buildSectionHeader(
                            "Super Growth Leave-in Conditioners"),
                        _buildHorizontalProductList(),

                        _buildSectionHeader(
                            "Firm & Lift Skin Products"),
                        _buildHorizontalProductList(),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding:
      EdgeInsets.only(left: 20.w, top: 20.h, bottom: 10.h),
      child: CustomText(
        text: title,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: Color(0XFF000000),
      ),
    );
  }

  Widget _buildHorizontalProductList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 20.w),
      child: Row(
        // In a real app, you would map through a list of product objects here
        children: [
          _buildProductItem(
            title: "Skie Deep Cleansing Avocado Clay Mask",
            price: "17.99",
            imageUrl: "https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=200",
          ),
          _buildProductItem(
            title: "Skie Jojoba Castor Hair Growth Oil",
            price: "15.00",
            imageUrl: "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?q=80&w=200",
          ),
          _buildProductItem(
            title: "Skie Coconut & Peach Pomade",
            price: "12.50",
            imageUrl: "https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?q=80&w=200",
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem({required String title, required String price, required String imageUrl}) {
    return GestureDetector(
      onTap: () {
        // Passing data via Get.to
        Get.toNamed(RouteConstants.productDetailsScreen, arguments:{
          'title': title,
          'price': price,
          'image': imageUrl,
        });

      },
      child: Container(
        width: 160.w,
        margin: EdgeInsets.only(right: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              imageUrl: imageUrl,
              height: 180.h,
              width: 160.w,
              borderRadius: BorderRadius.circular(20.r),
            ),
            SizedBox(height: 8.h),
            CustomText(
              text: title,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              maxLines: 2,
              color: Color(0XFF000000),
            ),
            CustomText(
              text: "3 Blends",
              fontSize: 9.sp,
              color: Color(0x99000000),
              // color: Colors.grey,
            ),
            CustomText(
              text: "\$ $price",
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: Color(0XFF000000),
            ),
          ],
        ),
      ),
    );
  }
}
