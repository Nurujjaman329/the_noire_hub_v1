
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../controller/registration_controller.dart';

class CustomerAddressAddScreen extends GetView<RegistrationController> {
  const CustomerAddressAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: CustomText(text: "Add Address", fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Phone Number Section
              CustomText(
                text: "Add Phone Number",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF000000),
                top: 10.h,
              ),
              CustomText(
                text: "Enter your phone number for account verification",
                fontSize: 12.sp,
                color: const Color(0x4D000000),
                top: 8.h,
                bottom: 25.h,
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  SizedBox(width: 15.w),
                  Expanded(
                    child: CustomTextField(
                      controller: controller.phoneController, // Add this to your controller
                      labelText: "Phone",
                      keyboardType: TextInputType.phone,
                      hintText: "840 - 4500",
                    ),
                  ),
                ],
              ),

              const Divider(height: 50),

              // 2. Search Section with Suggestions
              CustomText(
                text: "Add Address",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0XFF000000),
                bottom: 15.h,
              ),

              // Search Input
              CustomTextField(
                controller: controller.searchController,
                labelText: "Search Location",
                hintText: "Enter neighborhood or street",
                prefixIcon: Icons.search,
                onChanged: (value) => controller.onSearchChanged(value),
              ),

              // Floating Suggestion List
              Obx(() => controller.placePredictions.isNotEmpty
                  ? Container(
                margin: EdgeInsets.only(top: 5.h),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.placePredictions.length,
                  itemBuilder: (context, index) {
                    final item = controller.placePredictions[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on_outlined, size: 18),
                      title: Text(item['description'], style: TextStyle(fontSize: 13.sp)),
                      onTap: () => controller.selectPrediction(item),
                    );
                  },
                ),
              )
                  : const SizedBox.shrink()),

              SizedBox(height: 20.h),

              // 3. Map Header & Pin Location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(text: "Pin Location", fontSize: 14.sp, fontWeight: FontWeight.w600),
                  GestureDetector(
                    onTap: () => controller.getCurrentLocation(),
                    child: Row(
                      children: [
                        const Icon(Icons.my_location, size: 14, color: Color(0XFFB5B475)),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: "Use Current Location",
                          fontSize: 12.sp,
                          color: const Color(0XFFB5B475),
                          fontWeight: FontWeight.w600,
                          textDecoration: TextDecoration.underline,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // 4. GOOGLE MAP
              Container(
                height: 250.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Obx(() => GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: controller.selectedLatLng.value,
                        zoom: 14
                    ),
                    onMapCreated: controller.onMapCreated,
                    onTap: (latLng) => controller.updateLocation(latLng),
                    markers: {
                      Marker(
                        markerId: const MarkerId("selected"),
                        position: controller.selectedLatLng.value,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                      ),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  )),
                ),
              ),

              SizedBox(height: 25.h),

              // 5. Selected Address Display
              CustomText(text: "Selected Address", fontSize: 14.sp, fontWeight: FontWeight.w600, bottom: 8.h),
              Obx(() => Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0XFF1D3826)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomText(
                        text: controller.currentAddressString.value.isEmpty
                            ? "Fetching address..."
                            : controller.currentAddressString.value,
                        fontSize: 13.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              )),

              SizedBox(height: 40.h),

              // 6. FINAL API CALL
              Obx(() => CustomButton(
                text: "Create Account",
                color: const Color(0XFF1D3826),
                loading: controller.isLoading.value,
                onTap: () {
                  controller.addAddress(
                      controller.selectedCountry.value,
                      controller.selectedCity.value,
                      controller.selectedLatLng.value.latitude,
                      controller.selectedLatLng.value.longitude
                  );
                  controller.register();
                },
              )),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}