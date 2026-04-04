import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import 'package:get/get.dart';

import '../../data/average_review_response_model.dart';
import '../controller/average_review_controller.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject or find the controller
    final controller = Get.find<AverageReviewController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Reviews & Ratings",
        showBackButton: true,
      ),
      body: Obx(() {
        // Show loading state
        if (controller.isLoading.value && controller.reviewData.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.reviewData.value;

        // Optional: Show empty state if no reviews exist
        if (data == null || data.evaluations.isEmpty) {
          return Center(child: CustomText(text: "No reviews yet."));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchEvaluations(),
          color: AppColors.secondaryVariant,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // 1. Overall Rating Summary Header (Dynamic)
                _buildRatingSummary(controller, data),

                const Divider(thickness: 1, color: AppColors.divider),

                // 2. Individual Reviews List (Dynamic)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Customer Feedback",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                        bottom: 20.h,
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.evaluations.length,
                        itemBuilder: (context, index) {
                          final review = data.evaluations[index];

                          // Helper to format the date
                          String dateStr = "N/A";
                          if (review.createdAt != null) {
                            // Using timeago or DateFormat here
                            dateStr = "${review.createdAt!.day}/${review.createdAt!.month}/${review.createdAt!.year}";
                          }

                          return _buildReviewItem(
                            name: review.user.fullName,
                            rating: review.rating,
                            date: dateStr,
                            comment: review.comment,
                            imageUrl: review.user.image, // Base URL should be handled in model or here
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRatingSummary(AverageReviewController controller, EvaluationAttributes data) {
    return Container(
      padding: EdgeInsets.all(25.r),
      child: Row(
        children: [
          // Left Side: Big Number
          Expanded(
            flex: 2,
            child: Column(
              children: [
                CustomText(
                  text: data.averageRating.toStringAsFixed(1),
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => Icon(
                    Icons.star_rounded,
                    color: index < data.averageRating.floor() ? Colors.orange : Colors.grey.shade300,
                    size: 20.sp,
                  )),
                ),
                CustomText(
                  text: "${data.totalReviews} Reviews",
                  fontSize: 12.sp,
                  color: AppColors.geryColor,
                  top: 8.h,
                ),
              ],
            ),
          ),

          // Right Side: Progress Bars (Dynamic via Controller)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildRatingBar("5", controller.calculateRatingRatio("5")),
                _buildRatingBar("4", controller.calculateRatingRatio("4")),
                _buildRatingBar("3", controller.calculateRatingRatio("3")),
                _buildRatingBar("2", controller.calculateRatingRatio("2")),
                _buildRatingBar("1", controller.calculateRatingRatio("1")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String star, double progress) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          CustomText(text: star, fontSize: 12.sp, color: AppColors.primaryDark),
          SizedBox(width: 8.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6.h,
                backgroundColor: AppColors.divider,
                color: AppColors.secondaryVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required int rating,
    required String date,
    required String comment,
    required String imageUrl,
  }) {
    // Add base URL if your API image path is relative
    String fullImageUrl = imageUrl.startsWith('http') ? imageUrl : "${ApiConstants.baseUrl}$imageUrl";

    return Padding(
      padding: EdgeInsets.only(bottom: 25.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomNetworkImage(
                imageUrl: fullImageUrl,
                height: 45.r,
                width: 45.r,
                boxShape: BoxShape.circle,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: name, fontSize: 15.sp, fontWeight: FontWeight.bold),
                    Row(
                      children: List.generate(5, (index) => Icon(
                        Icons.star_rounded,
                        color: index < rating ? Colors.orange : Colors.grey.shade300,
                        size: 14.sp,
                      )),
                    ),
                  ],
                ),
              ),
              CustomText(text: date, fontSize: 11.sp, color: AppColors.geryColor),
            ],
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: comment,
            fontSize: 13.sp,
            color: AppColors.textPrimary.withValues(alpha:0.8),
          ),
        ],
      ),
    );
  }
}