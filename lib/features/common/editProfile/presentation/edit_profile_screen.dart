import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_noire_hub_v1/core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/cache_service.dart';
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
                  _editTile(label: "Phone Number", controller: controller.phoneController, icon: Icons.phone_android_outlined),
                  _editTile(
                    label: "Address",
                    controller: controller.addressController,
                    icon: Icons.location_on_outlined,
                    readOnly: false,
                    mainController: controller
                  ),
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
    // ✅ NO MORE MODEL: Use the controller's path or the cached image URL
    debugPrint("🙌Selected Image Path: ${ApiConstants.baseImageUrl}${CacheService.userImage}");
    // You can add 'static String get userImage => _prefs.getString('user_image') ?? "";' to CacheService
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
                // Pull from CacheService directly
                imageUrl: "${ApiConstants.baseImageUrl}${CacheService.userImage}",
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

  Widget _editTile({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    EditProfileController? mainController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- MAIN INPUT TILE ---
        Container(
          margin: EdgeInsets.only(bottom: 8.h),
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
                  readOnly: readOnly,
                  onTap: onTap,
                  style: TextStyle(fontSize: 14.sp),
                  // TRIGGER SEARCH ON THE MAIN FIELD
                  onChanged: (val) {
                    if (label == "Address" && mainController != null) {
                      mainController.onSearchChanged(val);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- SUGGESTIONS LIST (Only for Address) ---
        if (label == "Address" && mainController != null)
          Obx(() {
            if (mainController.placePredictions.isEmpty) return const SizedBox.shrink();
            return Container(
              margin: EdgeInsets.only(bottom: 12.h, left: 10.w, right: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mainController.placePredictions.length,
                itemBuilder: (_, index) {
                  final pred = mainController.placePredictions[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.location_on, size: 18, color: Color(0xFF707E5F)),
                    title: Text(pred['description'] ?? "", style: TextStyle(fontSize: 13.sp)),
                    onTap: () => mainController.selectPrediction(pred),
                  );
                },
              ),
            );
          }),

        // --- MINI MAP (Only for Address) ---
        if (label == "Address" && mainController != null)
          Obx(() => Container(
            height: 180.h,
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: const Color(0xFFF1F4D3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: mainController.selectedLatLng.value,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("selected-location"),
                    position: mainController.selectedLatLng.value,
                    draggable: true,
                    onDragEnd: (pos) => mainController.updateLocation(pos),
                  ),
                },
                onMapCreated: mainController.onMapCreated,
                myLocationEnabled: true,
                zoomControlsEnabled: false, // Cleaner look
                myLocationButtonEnabled: false,
              ),
            ),
          )),
      ],
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