import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Reviews & Ratings",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Overall Rating Summary Header
            _buildRatingSummary(),

            const Divider(thickness: 1, color: AppColors.divider),

            // 2. Individual Reviews List
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
                  _buildReviewItem(
                    name: "Sarah Jenkins",
                    rating: 5,
                    date: "2 days ago",
                    comment: "The hair quality is absolutely amazing! I've been wearing the extensions for a week now and no tangling at all.",
                    imageUrl: "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg",
                  ),
                  _buildReviewItem(
                    name: "Michael Chen",
                    rating: 4,
                    date: "1 week ago",
                    comment: "Great service and fast shipping to Canada. The packaging was very professional.",
                    imageUrl: "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
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
                  text: "4.8",
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => Icon(
                    Icons.star_rounded,
                    color: index < 4 ? Colors.orange : Colors.grey.shade300,
                    size: 20.sp,
                  )),
                ),
                CustomText(
                  text: "124 Reviews",
                  fontSize: 12.sp,
                  color: AppColors.geryColor,
                  top: 8.h,
                ),
              ],
            ),
          ),

          // Right Side: Progress Bars
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildRatingBar("5", 0.8),
                _buildRatingBar("4", 0.6),
                _buildRatingBar("3", 0.1),
                _buildRatingBar("2", 0.05),
                _buildRatingBar("1", 0.02),
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
                color: AppColors.secondaryVariant, // Your brand olive green
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
    return Padding(
      padding: EdgeInsets.only(bottom: 25.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomNetworkImage(
                imageUrl: imageUrl,
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
            color: AppColors.textPrimary.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}