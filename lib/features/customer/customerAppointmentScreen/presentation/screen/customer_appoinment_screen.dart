import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_dropdown.dart';
import '../../../../../core/widgets/custom_text.dart';

class CustomerAppoinmentScreen extends StatefulWidget {
  const CustomerAppoinmentScreen({super.key});

  @override
  State<CustomerAppoinmentScreen> createState() => _CustomerAppoinmentScreenState();
}

class _CustomerAppoinmentScreenState extends State<CustomerAppoinmentScreen> {
  final DateTime _focusedDay = DateTime(2020, 10, 14);
  final DateTime _selectedDay = DateTime(2020, 10, 14);
  String? _selectedLocation = "72 Poplar Ave NW, Toronto, ON, M7T8Z2";
  bool isLoading = false;
  final List<String> _subcategories = [
    "Knotless Braids",
    "Box Braids",
    "Cornrows",
    "Dreadlocks",
    "Silk Press",
    "Wig Installation"
  ];

  // 2. Set the initial selected value
  String? _selectedSubcategory = "Knotless Braids";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: "Book An Appointment",
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E2F23),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            // 1. Location Selection using your CustomDropdown
            CustomDropdown<String>(
              isBoxStyle: true,
              width: double.infinity,
              height: 65.h,
              prefixIcon: Icons.location_on,
              value: _selectedLocation,
              items: [_selectedLocation!],
              itemAsString: (val) => val,
              onChanged: (val) => setState(() => _selectedLocation = val),
            ),

            SizedBox(height: 15.h),

            // 2. Calendar and Time Selection Box
            _buildDateTimeCard(),

            SizedBox(height: 25.h),
            CustomText(text: "Choose a Service", fontSize: 14.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 15.h),

            // 3. Specialties List (Hair, Makeup, etc.)
            _buildSpecialtiesList(),

            SizedBox(height: 25.h),
            CustomText(text: "Choose a subcategory", fontSize: 14.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 15.h),

            // 4. Subcategory Dropdown
            CustomDropdown<String>(
              isBoxStyle: true,
              width: double.infinity,
              height: 55.h,
              value: _selectedSubcategory,
              items: _subcategories, // Use the full list here
              itemAsString: (val) => val,
              onChanged: (val) {
                setState(() {
                  _selectedSubcategory = val;
                });
              },
            ),

            SizedBox(height: 40.h),

            // 5. Continue Button
            CustomButton(
              text: "Continue",
              color: AppColors.primaryDark,
              loading: isLoading,
              onTap: () {
                setState(() => isLoading = true);
                // Registration logic here
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() => isLoading = false);
                });
              },
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeCard() {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month, color: Colors.grey, size: 28.sp),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "Choose a Date", fontSize: 14.sp, fontWeight: FontWeight.bold),
                  CustomText(text: "14 Oct 2020", fontSize: 12.sp, color: Colors.grey),
                ],
              ),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_up, color: Colors.grey),
            ],
          ),
          SizedBox(height: 15.h),

          // Direct Inline Calendar (Requires table_calendar package)
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TableCalendar(
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(color: Color(0xFFC4C99A), shape: BoxShape.circle),
                todayDecoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: const Color(0xFFC4C99A))),
                defaultTextStyle: const TextStyle(color: Colors.black),
              ),
            ),
          ),

          SizedBox(height: 20.h),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(text: "Choose a Time (Optional)", fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 10.h),

          // Time Pickers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _timeBox("01"),
              _timeBox("00"),
              _timeBox("AM"),
              _timeBox("MST"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String text) {
    return Container(
      width: 65.w,
      height: 45.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E5E5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: CustomText(text: text, fontSize: 16.sp, fontWeight: FontWeight.w500),
    );
  }

  // Use the service widgets you provided
  Widget _buildSpecialtiesList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _specialtyCard("Hair", "https://cdn-icons-png.flaticon.com/512/1940/1940922.png", AppColors.primary, AppColors.textPrimary),
          _specialtyCard("Make Up", "https://cdn-icons-png.flaticon.com/512/1940/1940922.png", AppColors.primary, AppColors.textPrimary),
          _specialtyCard("Nails", "https://cdn-icons-png.flaticon.com/512/1940/1940922.png", AppColors.primary, AppColors.textPrimary),
          _specialtyCard("Hair Removal", "https://cdn-icons-png.flaticon.com/512/1940/1940922.png", AppColors.primary, AppColors.textPrimary),
        ],
      ),
    );
  }

  Widget _specialtyCard(String title, String imageUrl, Color bg, Color textColor) {
    return Container(
      width: 110.w,
      height: 130.h,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(35.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 70.h,
            child: Image.network(imageUrl, fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.face, color: textColor)),
          ),
          CustomText(text: title, fontSize: 12.sp, fontWeight: FontWeight.bold, color: textColor, top: 8.h),
        ],
      ),
    );
  }
}