

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../customerOrderScreen/data/customer_orders_response_model.dart';
import 'controller/product_rating_controller.dart';

class ProductRatingScreen extends StatefulWidget {
  const ProductRatingScreen({super.key});

  @override
  State<ProductRatingScreen> createState() => _ProductRatingScreenState();
}

class _ProductRatingScreenState extends State<ProductRatingScreen> {
  final ratingController = Get.find<ProductRatingController>();

  // Use OrderDoc instead of BookingDoc
  late final OrderDoc orderData;
  late final OrderItem? firstItem;

  @override
  void initState() {
    super.initState();
    // Initialize orderData from arguments passed in OrderHistoryCard
    orderData = Get.arguments;
    firstItem = orderData.items.isNotEmpty ? orderData.items.first : null;
    ratingController.selectedRating.value = 5;
  }

  @override
  Widget build(BuildContext context) {
    // Format the creation date of the order
    String formattedDate = orderData.createdAt.isNotEmpty
        ? DateFormat('MMMM dd, yyyy').format(DateTime.parse(orderData.createdAt))
        : "N/A";

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Image Section
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35.r),
                    bottomRight: Radius.circular(35.r),
                  ),
                  child: CustomNetworkImage(
                    imageUrl: firstItem?.productImage ?? "",
                    height: 300.h,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18.sp),
                    ),
                  ),
                ),
              ],
            ),

            // 2. The Floating Rating Card
            Transform.translate(
              offset: Offset(0, -60.h),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: _buildRatingCard(formattedDate),
              ),
            ),

            SizedBox(height: 5.h),

            // 3. Review Text Field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Container(
                height: 150.h,
                padding: EdgeInsets.all(15.r),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: TextField(
                  controller: ratingController.commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Leave a review",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.h),

            // 4. Submit Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Obx(() => CustomButton(
                text: ratingController.isLoading.value ? "Submitting..." : "Submit",
                onTap: ratingController.isLoading.value
                    ? null
                    : () => ratingController.submitProductReview(
                  productId: firstItem?.product ?? "",
                  orderId: orderData.id,
                ),
              )),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard(String date) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: "Rate Product",
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          SizedBox(height: 15.h),

          CustomText(
            text: firstItem?.productName ?? "Product",
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          CustomText(
            text: "Order ID: #${orderData.id.substring(orderData.id.length - 6).toUpperCase()}",
            fontSize: 11.sp,
            color: Colors.grey,
          ),

          CustomText(
            text: "Delivered on $date",
            fontSize: 11.sp,
            color: Colors.grey,
          ),
          SizedBox(height: 20.h),

          // Star Rating Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text: "Rate", fontSize: 14.sp, fontWeight: FontWeight.bold),
              SizedBox(width: 15.w),
              Obx(() => Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      ratingController.selectedRating.value = index + 1;
                      HapticFeedback.lightImpact();
                    },
                    child: Icon(
                      Icons.star,
                      color: index < ratingController.selectedRating.value
                          ? const Color(0xFFC4C900)
                          : Colors.grey.shade300,
                      size: 32.sp,
                    ),
                  );
                }),
              )),
            ],
          ),

          Obx(() => Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: CustomText(
              text: _getRatingText(ratingController.selectedRating.value),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFC4C900),
            ),
          )),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1: return "Poor";
      case 2: return "Fair";
      case 3: return "Good";
      case 4: return "Very Good";
      case 5: return "Excellent";
      default: return "";
    }
  }
}