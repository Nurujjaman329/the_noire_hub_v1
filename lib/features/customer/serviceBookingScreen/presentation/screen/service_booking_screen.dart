
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';


class ServiceBookingScreen extends StatefulWidget {
  const ServiceBookingScreen({super.key});

  @override
  State<ServiceBookingScreen> createState() => _ServiceBookingScreenState();
}

class _ServiceBookingScreenState extends State<ServiceBookingScreen> {
  String selectedSize = "Medium";
  String selectedLength = "Armpit";
  String selectedLocation = "Salon";

  @override
  Widget build(BuildContext context) {
    final dynamic data = Get.arguments;
    final String title = data['title'] ?? "Service Provider";
    final String imageUrl = data['imageUrl'] ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(imageUrl, title),
                  const Divider(thickness: 3, color: Color(0xFFC4C99A)),

                  _buildListSelectionSection(
                      "Size",
                      "how thick would you prefer?",
                      <Map<String, String>>[
                        {"name": "Micro", "price": "+\$100"},
                        {"name": "Mini", "price": "+\$80"},
                        {"name": "Small", "price": "+\$60"},
                        {"name": "Medium", "price": "+\$40"},
                        {"name": "Large", "price": "+\$20"},
                        {"name": "Jumbo", "price": ""},
                      ],
                      selectedSize,
                          (val) => setState(() => selectedSize = val!)
                  ),

                  _buildListSelectionSection(
                      "Length",
                      "how long would you prefer?",
                      <Map<String, String>>[
                        {"name": "Knee", "price": "+\$100"},
                        {"name": "Butt Length", "price": "+\$80"},
                        {"name": "Waist", "price": "+\$60"},
                        {"name": "Armpit", "price": "+\$40"},
                        {"name": "Shoulder", "price": "+\$20"},
                      ],
                      selectedLength,
                          (val) => setState(() => selectedLength = val!)
                  ),

                  _buildListSelectionSection(
                      "Location",
                      "where would you prefer to meet?",
                      <Map<String, String>>[
                        {"name": "Home Service", "price": ""},
                        {"name": "Salon", "price": ""},
                      ],
                      selectedLocation,
                          (val) => setState(() => selectedLocation = val!)
                  ),

                  _buildCalendarSection(),
                  _buildTimePickerSection(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
          // Pass variables to button helper
          _buildBottomButton(imageUrl, title),
        ],
      ),
    );
  }

  // Updated to receive current image and title
  Widget _buildBottomButton(String img, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(25.w, 10.h, 25.w, 35.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: CustomButton(
        text: "Book | \$180.00",
        onTap: () {
          Get.toNamed(
            RouteConstants.customerConfirmBookings,
            arguments: {
              'img': img,
              'title': title,
              'size': selectedSize,
              'length': selectedLength,
              'location': selectedLocation,
            },
          );
        },

        textColor: Color(0XFFF1F0B2),
        fontSize: 16.sp,
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildHeader(String img, String title) {
    return Stack(
      children: [
        Image.network(img, height: 280.h, width: double.infinity, fit: BoxFit.cover),
        Positioned(
          top: 50.h,
          left: 20.w,
          child: GestureDetector(
            onTap: () => Get.back(),
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha:0.5),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 220.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.r),
                topRight: Radius.circular(40.r)
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            children: [
              CustomText(text: title, fontSize: 24.sp, fontWeight: FontWeight.bold),
              SizedBox(height: 5.h),
              CustomText(
                  text: "\$100 | Braids with natural looking roots",
                  fontSize: 13.sp,
                  color: Colors.black87
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListSelectionSection(String title, String sub, List<Map<String, String>> options, String current, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(25.w, 20.h, 25.w, 10.h),
          child: RichText(
            text: TextSpan(
              text: "$title ",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp, fontFamily: "Outfit"),
              children: [
                TextSpan(
                    text: "| $sub",
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11.sp, color: Colors.black54)
                )
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F4D3)),
        Column(
          children: options.map((opt) {
            return Column(
              children: [
                RadioListTile<String>(
                  value: opt['name']!,
                  groupValue: current,
                  onChanged: onChanged,
                  activeColor: const Color(0xFF2D3E2F),
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: opt['name']!, fontSize: 14.sp, fontWeight: FontWeight.bold),
                      if (opt['price'] != null && opt['price']!.isNotEmpty)
                        CustomText(text: opt['price']!, fontSize: 10.sp, color: Colors.grey),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F4D3)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCalendarSection() {
    // Define your available dates
    final List<int> availableDates = [3, 9, 20, 24, 26, 30];
    final int daysInMonth = 31; // Example for January

    return Padding(
      padding: EdgeInsets.fromLTRB(25.w, 25.h, 25.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              text: "Available Dates",
              fontWeight: FontWeight.bold,
              fontSize: 18.sp
          ),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.all(15.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4D3).withValues(alpha:0.3),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFFC4C99A).withValues(alpha:0.5)),
            ),
            child: Column(
              children: [
                // Calendar Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                        text: "January 2026",
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 14),
                  ],
                ),
                SizedBox(height: 15.h),

                // Days of week header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                      .map((day) => CustomText(
                      text: day,
                      fontSize: 10.sp,
                      color: Colors.grey
                  ))
                      .toList(),
                ),
                SizedBox(height: 10.h),

                // Calendar Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: daysInMonth,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    int day = index + 1;
                    bool isAvailable = availableDates.contains(day);

                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // Highlight available dates with your Primary Green
                        color: isAvailable
                            ? const Color(0xFF2D3E2F)
                            : Colors.transparent,
                      ),
                      alignment: Alignment.center,
                      child: CustomText(
                        text: day.toString(),
                        fontSize: 12.sp,
                        fontWeight: isAvailable ? FontWeight.bold : FontWeight.normal,
                        color: isAvailable ? Colors.white : Colors.black87,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFC4C99A)),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _timeBox("01"), _timeBox("00"), _timeBox("AM"), _timeBox("MST"),
          ],
        ),
      ),
    );
  }

  Widget _timeBox(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: const Color(0xFFE4E4E4),
          borderRadius: BorderRadius.circular(10.r)
      ),
      child: CustomText(text: text, fontWeight: FontWeight.bold),
    );
  }

}