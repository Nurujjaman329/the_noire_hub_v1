
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class CustomerAddressAddScreen extends StatefulWidget {
  const CustomerAddressAddScreen({super.key});

  @override
  State<CustomerAddressAddScreen> createState() => _CustomerAddressAddScreenState();
}

class _CustomerAddressAddScreenState extends State<CustomerAddressAddScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String selectedCountryCode = "+ 1";
  bool isSubmitting = false; // To test your button's loading state
  bool _isMapLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20.sp, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Section using CustomText
              CustomText(
                text: "Add Phone Number",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                // color: AppColors.textPrimary,
                color: Color(0XFF000000),
                textAlign: TextAlign.left,
                top: 10.h,
              ),
              CustomText(
                text: "Enter the best phone number to send important notifications to",
                fontSize: 12.sp,
                color: Color(0x4D000000),
                // color: Colors.grey,
                textAlign: TextAlign.left,
                top: 8.h,
                bottom: 35.h,
              ),

              // 2. Phone Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      CustomDropdown<String>(
                        isBoxStyle: true,
                        labelText: "Country",
                        width: 90.w,
                        value: selectedCountryCode,
                        items: const ["+ 1", "+ 44", "+ 234"],
                        itemAsString: (val) => val,
                        onChanged: (val) => setState(() => selectedCountryCode = val!),
                      ),
                    ],
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: CustomTextField(
                      controller: phoneController,
                      labelText: "Phone",
                      keyboardType: TextInputType.phone,
                      hintText: "840 - 45|",
                    ),
                  ),
                ],
              ),

              SizedBox(height: 35.h),

              // 3. Address Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Add Address",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFF000000),
                    // color: AppColors.textPrimary,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: CustomText(
                      text: "Use Current Location",
                      fontSize: 12.sp,
                      color: Color(0XFFB5B475),
                      // color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      textDecoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20.h),
              CustomTextField(
                controller: addressController,
                labelText: "Address",
                hintText: "Type your address",
                prefixIcon: Icons.location_on_outlined,
              ),

              // 4. Map Mock
              CustomText(
                text: "Choose Location",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Color(0XFF000000),
                // color: AppColors.textPrimary,
                top: 35.h,
                bottom: 15.h,
              ),
              Container(
                height: 250.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.grey.shade200), // Subtle border
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(6.5244, 3.3792), // Default location (e.g., Lagos)
                          zoom: 14.0,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          // Store the controller if needed for future interactions
                          // Example: if you want to move the marker or update location
                          setState(() {
                            _isMapLoaded = true;
                          });
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId("selected_location"),
                            position: const LatLng(6.5244, 3.3792),
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                          ),
                        },
                        // Enable location related features
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        // Disable unnecessary UI elements for a cleaner look
                        zoomControlsEnabled: false,
                        mapType: MapType.normal,
                        // Add gesture controls
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        tiltGesturesEnabled: true,
                      ),
                      if (!_isMapLoaded)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryDark),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // 5. Final Button using your CustomButton widget
              CustomButton(
                text: "Create Account",
                color: Color(0XFF1D3826),
                // color: AppColors.primaryDark,
                loading: isSubmitting,
                onTap: () async {
                  setState(() => isSubmitting = true);
                  await Future.delayed(const Duration(seconds: 2)); // Mock API delay
                  setState(() => isSubmitting = false);
                  Get.toNamed(RouteConstants.otpVerifyScreen);
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}