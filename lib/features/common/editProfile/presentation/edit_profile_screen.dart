import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';


class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Edit Profile",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),

            // 1. Profile Image Section
            _buildProfileImage(),

            SizedBox(height: 40.h),

            // 2. Info Fields Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  _infoTile(label: "Full Name", value: "Jane Cooper", icon: Icons.person_outline),
                  _infoTile(label: "Email Address", value: "jane.cooper@example.com", icon: Icons.mail_outline),
                  _infoTile(label: "Phone Number", value: "+1 234 567 890", icon: Icons.phone_android_outlined),
                  _infoTile(label: "Default Address", value: "123 Green Valley, New York", icon: Icons.location_on_outlined),
                  _infoTile(label: "Date of Birth", value: "12 May 1995", icon: Icons.calendar_today_outlined),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // 3. Edit Button
            _buildEditButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
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
              imageUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200",
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
      child: CustomButton(onTap: (){}, text: "Update Profile"),
    );
  }
}