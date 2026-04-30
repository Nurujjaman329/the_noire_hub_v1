import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';

import 'package:intl/intl.dart';

import '../controller/customer_deals_promos_controller.dart';


class CustomerDealsPromosScreen extends StatelessWidget {
  const CustomerDealsPromosScreen({super.key});

  static String vendorStoreTop = AppAssets.registration;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerDealsPromosController>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: RefreshIndicator(
        onRefresh: () => controller.fetchPromos(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // 1. Top Image Header
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
                        child: Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 20.sp),
                      ),
                    ),
                  ),
                ],
              ),

              // 2. History Section
              // GestureDetector(
              //   onTap: () => Get.toNamed(RouteConstants.dealsPromosHistory),
              //   child: _buildWhiteCard(
              //     margin: EdgeInsets.only(left: 25.w, right: 25.w, bottom: 20.h, top: 20.h),
              //     child: ListTile(
              //       leading: Container(
              //         padding: EdgeInsets.all(8.r),
              //         decoration: const BoxDecoration(
              //             color: Colors.black, shape: BoxShape.circle),
              //         child: Icon(Icons.percent, color: Colors.white, size: 20.sp),
              //       ),
              //       title: CustomText(
              //           text: "History",
              //           fontSize: 15.sp,
              //           fontWeight: FontWeight.bold),
              //       subtitle: CustomText(
              //           text: "Your Used Promos & Deals",
              //           fontSize: 11.sp,
              //           color: Colors.grey),
              //       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              //     ),
              //   ),
              // ),

              // 3. Available Promos List
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
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

                    Obx(() {
                      if (controller.isListLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.promoList.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: CustomText(text: "No promos available", color: Colors.grey),
                          ),
                        );
                      }

                      return _buildWhiteCard(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.promoList.length,
                          separatorBuilder: (context, index) => const Divider(color: AppColors.divider),
                          itemBuilder: (context, index) {
                            final promo = controller.promoList[index];

                            // Parsing the String date from model
                            String formattedExpiry = "N/A";
                            if (promo.expiryDate.isNotEmpty) {
                              try {
                                DateTime dateTime = DateTime.parse(promo.expiryDate);
                                formattedExpiry = DateFormat('MM/dd/yyyy').format(dateTime);
                              } catch (e) {
                                formattedExpiry = promo.expiryDate; // Fallback to raw string
                              }
                            }

                            return _promoTile(
                                "${promo.discountPercentage}% Discounts",
                                promo.code,
                                formattedExpiry
                            );
                          },
                        ),
                      );
                    }),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhiteCard({required Widget child, EdgeInsetsGeometry? margin}) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: child,
    );
  }

  Widget _promoTile(String title, String code, String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          // 1. Title and Subtitle Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Wrap text in Flexible to prevent overflow
                    Flexible(
                      child: CustomText(
                        text: title,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // The Code Tag
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: CustomText(
                        text: code,
                        fontSize: 10.sp,
                        color: AppColors.background,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: "Exp: $date",
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),

          // 2. Action Button
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () => _showSuccessDialog(title),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                  color: const Color(0xFF9BB575),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9BB575).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
              ),
              child: CustomText(
                text: "Apply",
                fontSize: 11.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String promoName) {
    Get.defaultDialog(
      title: "",
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      radius: 20.r,
      content: Column(
        children: [
          CustomText(
            text: "Hooray!",
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF9BB575),
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: "$promoName is applied to your account",
            fontSize: 14.sp,
            textAlign: TextAlign.center,
            color: Colors.black54,
          ),
          SizedBox(height: 25.h),
          CustomButton(
            color: const Color(0xFF9BB575),
            text: "Start Shopping",
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}