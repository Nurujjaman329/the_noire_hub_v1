import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/accountController/account_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF3F592B),
      // backgroundColor: AppColors.primaryDark,
      appBar: CustomAppBar(
        title: "",
        bgColor: Colors.transparent,
        showBackButton: true,
         arrowColor: AppColors.white,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 60.h),
            decoration: BoxDecoration(
              color: AppColors.white, // Standard white background
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.r),
                topRight: Radius.circular(50.r),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                children: [
                  SizedBox(height: 75.h),

                  CustomText(
                    text: "Amina Bashir",
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark, // Brand text color
                  ),
                  SizedBox(height: 25.h),

                  _buildQuickActions(),
                  SizedBox(height: 20.h),

                  _buildSettingsList(),
                  SizedBox(height: 20.h),
                  _buildSignOutSection(),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),

          // 1. Profile Image
          Positioned(
            top: 0,
            child: CustomNetworkImage(
              imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
              height: 120.h,
              width: 120.w,
              boxShape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 4),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildQuickActions() {
    final accountCtrl = Get.find<AccountController>();

    if (accountCtrl.isCustomer) {
      return Row(
        children: [
          // Expanded ensures they take equal width with a gap in between
          Expanded(
            child: _actionBox(
              "Favorites",
              Icons.favorite_outline_rounded,
              bgColor: const Color(0xFFCAD99E), // Dark Green for contrast
              textColor: const Color(0xFF000000), // Pale Yellow text
              onTap: () => Get.toNamed(RouteConstants.favouritesScreen),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: _actionBox(
              "Orders",
              Icons.assignment_outlined,
              bgColor: const Color(0xFFCAD99E), // Pale Yellow
              textColor: const Color(0xFF000000), // Black text
              onTap: () => Get.toNamed(RouteConstants.customerOrdersScreen),
            ),
          ),
        ],
      );
    } else if (accountCtrl.isBeautician) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [


          Expanded(
            child: _actionBox(
              "Rating",
              Icons.star_border,
              bgColor: const Color(0xFFCAD99E), // Dark Green for contrast
              textColor: const Color(0xFF000000), // Pale Yellow text
              onTap: () => Get.toNamed(RouteConstants.reviewScreen),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: _actionBox(
              "Wallet",
              Icons.account_balance_wallet_outlined,
              bgColor: const Color(0xFFCAD99E), // Pale Yellow
              textColor: const Color(0xFF000000), // Black text
              onTap: () => Get.toNamed(RouteConstants.walletScreen),
            ),
          ),

          // _actionBox("Rating", Icons.star_border, width: 105.w,onTap: () => Get.toNamed(RouteConstants.reviewScreen),),
          // _actionBox("Wallet", Icons.account_balance_wallet_outlined, width: 105.w,onTap: () => Get.toNamed(RouteConstants.walletScreen)),
          // _actionBox("Bookings", Icons.calendar_today_outlined, width: 105.w,onTap: () => Get.toNamed(RouteConstants.boo)),
        ],
      );
    }

    // Fallback for Vendor
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Expanded(
          child: _actionBox(
            "Rating",
            Icons.star_border,
            bgColor: const Color(0xFFCAD99E), // Dark Green for contrast
            textColor: const Color(0xFF000000), // Pale Yellow text
            onTap: () => Get.toNamed(RouteConstants.reviewScreen),
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: _actionBox(
            "Wallet",
            Icons.account_balance_wallet_outlined,
            bgColor: const Color(0xFFCAD99E), // Pale Yellow
            textColor: const Color(0xFF000000), // Black text
            onTap: () => Get.toNamed(RouteConstants.walletScreen),
          ),
        ),


        // _actionBox("Rating", Icons.star_border, width: 105.w,onTap: () => Get.toNamed(RouteConstants.reviewScreen)),
        // _actionBox("Wallet", Icons.credit_card_outlined, width: 105.w,onTap: () => Get.toNamed(RouteConstants.walletScreen)),
        // _actionBox("Orders", Icons.assignment_outlined, width: 105.w,onTap: () => Get.toNamed(RouteConstants.reviewScreen)),
      ],
    );
  }

  Widget _actionBox(
      String title,
      IconData icon, {
        VoidCallback? onTap,
        Color bgColor = const Color(0XFFCADA9F),
        Color textColor = const Color(0XFF000000),
        double? width,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 28.sp),
            SizedBox(height: 10.h),
            CustomText(
              text: title,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSettingsList() {
    final accountCtrl = Get.find<AccountController>();

    // 1. Define all possible items
    final List<Map<String, dynamic>> menuItems = [
      {"icon": Icons.person_outline, "label": "Personal Info"},
      {"icon": Icons.group_add_outlined, "label": "Invite Friends"},
      {"icon": Icons.local_offer_outlined, "label": "Deals & Promos"},
      {"icon": Icons.local_offer_outlined, "label": "Add Promo Code"},
      {"icon": Icons.help_outline, "label": "Help"},
      {"icon": Icons.visibility_off_outlined, "label": "Terms of Service"},
      {"icon": Icons.info_outline, "label": "About"},
      {"icon": Icons.password_outlined, "label": "Change Password"},
    ];

    // 2. Filter list: Remove 'Invite Friends' if user is NOT a customer
    final filteredItems = menuItems.where((item) {
      if (item['label'] == "Invite Friends") {
        return accountCtrl.isCustomer;
      }
      if (item['label'] == "Deals & Promos") {
        return accountCtrl.isCustomer;
      }
      if (item['label'] == "Add Promo Code") {
        return !accountCtrl.isCustomer;
      }
      return true;
    }).toList();

    return Column(
      children: filteredItems.map((item) {
        return InkWell(
          onTap: () {
            switch (item['label']) {
              case "Personal Info":
                Get.toNamed(RouteConstants.personalInfoScreen);
                break;
              case "Invite Friends":
                Get.toNamed(RouteConstants.inviteScreens);
                break;
              case "About":
                Get.toNamed(RouteConstants.aboutUsScreen);
                break;
              case "Terms of Service":
                Get.toNamed(RouteConstants.termsOfServiceScreen);
                break;
              case "Deals & Promos":
                Get.toNamed(RouteConstants.dealsPromos);
                break;
              case "Add Promo Code":
                Get.toNamed(RouteConstants.addDealsPromos);
                break;
              case "Help":
                Get.toNamed(RouteConstants.helpScreen);
                break;
              case "Change Password":
                Get.toNamed(RouteConstants.changePassword);
                break;
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Row(
              children: [
                Icon(item['icon'],color: Color(0XFF000000), size: 26.sp),
                SizedBox(width: 20.w),
                Expanded(
                  child: CustomText(
                    text: item['label'],
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0XFF000000),
                    // color: AppColors.primaryDark,
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.geryColor),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSignOutSection() {
    return InkWell(
      onTap: () => _showLogoutDialog(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.logout, color: Colors.redAccent, size: 22.sp),
            ),
            SizedBox(width: 20.w),
            CustomText(
              text: "Sign Out",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: "Sign Out",
      titleStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        // color: AppColors.primaryDark,
        color: const Color(0xFF9BB575),
      ),
      middleText: "Are you sure you want to sign out of your account?",
      middleTextStyle: TextStyle(fontSize: 14.sp),
      backgroundColor: AppColors.white,
      radius: 20.r,
      contentPadding: EdgeInsets.all(20.w),
      textCancel: "No",
      cancelTextColor: AppColors.primaryDark,
      onCancel: () => Get.back(),
      textConfirm: "Yes, Sign Out",
      confirmTextColor: AppColors.white,
      // buttonColor: AppColors.secondaryVariant, // Using the accent color for buttons
      buttonColor: const Color(0xFF9BB575),
      onConfirm: () {
        Get.offAllNamed(RouteConstants.login);
      },
    );
  }
}