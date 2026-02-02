import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text.dart';

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Invite Friends",showBackButton: true,),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              // 2. Main Promo Card
              _buildPromoCard(),

              SizedBox(height: 30.h),

              // 3. Action Grid (Copy, Share, Scan)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionSquare("Copy Link", Icons.copy_rounded),
                  _buildActionSquare("Share Link", Icons.send_rounded),
                ],
              ),

              SizedBox(height: 30.h),

              // 4. Details Section
              _buildDetailsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Color(0XFF9BB575),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Earn \$20 off any TNP Order when you invite a friend who joins TNP !",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Image.network(
              "https://cdn-icons-png.flaticon.com/512/9463/9463283.png", // Replace with your local asset
              height: 100.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSquare(String label, IconData icon) {
    return Container(
      width: 105.w,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color:Color(0XFFCADA9F),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 30.sp),
          SizedBox(height: 10.h),
          CustomText(
            text: label,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: Color(0XFF9BB575),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Details",
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            bottom: 15.h,
          ),
          CustomText(
            text: "Get a friend to register an account with TNP and place an order and earn \$20 off for every invited friend.",
            fontSize: 14.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}