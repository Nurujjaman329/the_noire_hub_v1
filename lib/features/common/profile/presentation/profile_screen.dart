import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../authentication/login/presentation/controller/logout_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get simple strings directly from static CacheService
    final String role = CacheService.role.toLowerCase();
    final String fullName = CacheService.userFullName.isNotEmpty ? CacheService.userFullName : "User Name";
    final String image = CacheService.userImage;
    final profileImg = image.isNotEmpty ? ApiConstants.baseImageUrl + image : '';

    // 2. Pure logic without model overhead
    final bool isCustomer = role == 'user' || role == 'customer';
    final bool isBeautician = role.contains('beautician');

    return Scaffold(
      backgroundColor: const Color(0XFF3F592B),
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
              color: AppColors.white,
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

                  // Dynamic Name from Cache
                  CustomText(
                    text: fullName,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                  SizedBox(height: 25.h),

                  _buildQuickActions(isCustomer, isBeautician),
                  SizedBox(height: 20.h),

                  _buildSettingsList(isCustomer),
                  SizedBox(height: 20.h),
                  _buildSignOutSection(),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),

          // Dynamic Profile Image from Cache
          Positioned(
            top: 0,
            child: CustomNetworkImage(
              imageUrl: profileImg,
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


  Widget _buildQuickActions(bool isCustomer, bool isBeautician) {

    if (isCustomer) {
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
    } else if (isBeautician) {
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
              color: Colors.black.withValues(alpha:0.05),
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


  Widget _buildSettingsList(bool isCustomer) {

    // 1. Define all possible items
    final List<Map<String, dynamic>> menuItems = [
      {"icon": Icons.person_outline, "label": "Personal Info"},
      {"icon": Icons.group_add_outlined, "label": "Invite Friends"},
      {"icon": Icons.message_outlined, "label": "Message to Admin"},
      {"icon": Icons.local_offer_outlined, "label": "Deals & Promos"},
      {"icon": Icons.local_offer_outlined, "label": "Add Promo Code"},
      {"icon": Icons.feedback_outlined, "label": "Admin Feedback"},
      {"icon": Icons.help_outline, "label": "Help"},
      {"icon": Icons.visibility_off_outlined, "label": "Terms of Service"},
      {"icon": Icons.info_outline, "label": "About"},
      {"icon": Icons.password_outlined, "label": "Change Password"},
    ];

    final filteredItems = menuItems.where((item) {
      if (item['label'] == "Message to Admin") return isCustomer;
      if (item['label'] == "Deals & Promos") return isCustomer;
      if (item['label'] == "Add Promo Code") return !isCustomer;
      if (item['label'] == "Admin Feedback") return !isCustomer;
      return true;
    }).toList();

    return Column(
      children: filteredItems.map((item) {
        return InkWell(
          onTap: () async {
            switch (item['label']) {
              case "Personal Info":
                Get.toNamed(RouteConstants.personalInfoScreen);
                break;
              case "Invite Friends":
                Get.toNamed(RouteConstants.inviteScreens);
                break;
              case "Message to Admin":
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'tonmoysds110@gmail.com',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'Support Request - ${CacheService.userFullName}',
                    'body': 'Hello Admin,\n\n',
                  }),
                );

                // Attempt to launch the email app
                try {
                  await launchUrl(emailLaunchUri);
                } catch (e) {
                  Get.snackbar(
                    "Error",
                    "Could not open email app",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
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
              case "Admin Feedback":
                Get.toNamed(RouteConstants.feedbackScreen);
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

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
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
                color: Colors.red.withValues(alpha:0.1),
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


  // void _handleMenuNavigation(String label) {
  //   switch (label) {
  //     case "Personal Info": Get.toNamed(RouteConstants.personalInfoScreen); break;
  //     case "Invite Friends": Get.toNamed(RouteConstants.inviteScreens); break;
  //     case "About": Get.toNamed(RouteConstants.aboutUsScreen); break;
  //     case "Terms of Service": Get.toNamed(RouteConstants.termsOfServiceScreen); break;
  //     case "Deals & Promos": Get.toNamed(RouteConstants.dealsPromos); break;
  //     case "Add Promo Code": Get.toNamed(RouteConstants.addDealsPromos); break;
  //     case "Help": Get.toNamed(RouteConstants.helpScreen); break;
  //     case "Change Password": Get.toNamed(RouteConstants.changePassword); break;
  //   }
  // }

  void _showLogoutDialog() {
    // Controller logic remains good
    final logoutCtrl = Get.put(LogoutController(Get.find()));

    Get.defaultDialog(
      title: "Sign Out",
      titleStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF9BB575),
      ),
      middleText: "Are you sure you want to sign out?",
      backgroundColor: AppColors.white,
      radius: 20.r,
      textCancel: "No",
      textConfirm: "Yes, Sign Out",
      confirmTextColor: AppColors.white,
      buttonColor: const Color(0xFF9BB575),
      onConfirm: () async {
        Get.back();
        await logoutCtrl.logout();
        Get.delete<LogoutController>();
      },
    );
  }
}