import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import 'controller/edit_profile_controller.dart';


class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Edit Profile", showBackButton: true),
      body: Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            _buildEditableImage(),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  _editTile(label: "Full Name", controller: controller.fullNameController, icon: Icons.person_outline),
                  _editTile(label: "Business Name", controller: controller.businessNameController, icon: Icons.business_outlined),
                  _editTile(label: "Phone Number", controller: controller.phoneController, icon: Icons.phone_android_outlined),
                  _editTile(label: "Address", controller: controller.addressController, icon: Icons.location_on_outlined),
                  _editTile(label: "Bio", controller: controller.bioController, icon: Icons.info_outline),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF707E5F)))
                : _buildSubmitButton(),
          ],
        ),
      )),
    );
  }

  Widget _buildEditableImage() {
    final user = LocalStorage.getUserModel();
    return Center(
      child: GestureDetector(
        onTap: () => _showImageSourceSheet(),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC4C99A), width: 2),
              ),
              child: controller.selectedImagePath.isEmpty
                  ? CustomNetworkImage(
                imageUrl: user?.fullProfileImageUrl ?? "",
                height: 100.h, width: 100.w,
                borderRadius: BorderRadius.circular(50.r),
              )
                  : ClipOval(
                child: Image.file(
                  File(controller.selectedImagePath.value),
                  height: 100.h, width: 100.w, fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: const BoxDecoration(color: Color(0xFF707E5F), shape: BoxShape.circle),
                child: Icon(Icons.camera_alt, color: Colors.white, size: 18.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Image Source", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.h),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF707E5F)),
              title: const Text("Camera"),
              onTap: () => controller.pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF707E5F)),
              title: const Text("Gallery"),
              onTap: () => controller.pickImage(ImageSource.gallery),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _editTile({required String label, required TextEditingController controller, required IconData icon}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
            child: TextField(
              controller: controller,
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: CustomButton(
          onTap: () => controller.updateProfile(),
          text: "Update Profile"
      ),
    );
  }
}