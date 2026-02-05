import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import 'controller/personal_info_controller.dart';


class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Find the controller (Injected via Binding)
    final PersonalInfoController controller = Get.find<PersonalInfoController>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Personal Information",
        showBackButton: true,
      ),
      body: Obx(() {
        // 2. Handle Loading State
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 3. Handle Error State
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: CustomText(text: controller.errorMessage.value, color: Colors.red));
        }

        final user = controller.userProfile.value;
        if (user == null) return const Center(child: Text("No Profile Found"));

        // Format address for display
        final String defaultAddress = user.addresses.isNotEmpty
            ? "${user.addresses.first.city}, ${user.addresses.first.country}"
            : "No address set";

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.h),

              // Dynamic Profile Image Section
              _buildProfileImage(user.image),

              SizedBox(height: 40.h),

              // Info Fields Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    _infoTile(label: "Full Name", value: user.fullName, icon: Icons.person_outline),
                    _infoTile(label: "Email Address", value: user.email, icon: Icons.mail_outline),
                    _infoTile(label: "Phone Number", value: user.phoneNumber ?? "Not provided", icon: Icons.phone_android_outlined),
                    _infoTile(label: "Default Address", value: defaultAddress, icon: Icons.location_on_outlined),
                    _infoTile(
                        label: "Date of Birth",
                        value: user.createdAt != null
                            ? "${user.createdAt!.day} / ${user.createdAt!.month} / ${user.createdAt!.year}"
                            : "Not set",
                        icon: Icons.calendar_today_outlined
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              _buildEditButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    // Generate full URL
    final String fullPath = imageUrl.isNotEmpty
        ? "${ApiConstants.baseImageUrl}$imageUrl"
        : "";

    return Center(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC4C99A), width: 2),
            ),
            child: CustomNetworkImage(
              imageUrl: fullPath,
              height: 100.h,
              width: 100.w,
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: const BoxDecoration(
                color: Color(0xFF707E5F),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.camera_alt, color: Colors.white, size: 18.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile({required String label, required String value, required IconData icon}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFFF1F4D3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF707E5F), size: 22.sp),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: label, fontSize: 11.sp, color: Colors.grey),
                SizedBox(height: 4.h),
                CustomText(text: value, fontSize: 14.sp, fontWeight: FontWeight.w600),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
      child: CustomButton(onTap: (){
        Get.toNamed(RouteConstants.editProfile);
      }, text: "Edit Profile"),
    );
  }
}