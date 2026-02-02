import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';

class EditServicesScreen extends StatefulWidget {
  const EditServicesScreen({super.key});

  @override
  State<EditServicesScreen> createState() => _EditServicesScreenState();
}

class _EditServicesScreenState extends State<EditServicesScreen> {

  DateTime _focusedDay = DateTime.now();
  final Set<DateTime> _selectedDates = {};
  bool applyToFullYear = false;
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D3826), // Deep green background for the sliver part
      body: CustomScrollView(
        slivers: [
          // 1. Top Logo Section (Moss Green)
          _buildSliverAppBar(),

          // 2. White Content Card
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomText(
                        text: "Edit Services",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1D3826),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Image Section with Upload Icon
                    _buildServiceImage(),

                    SizedBox(height: 25.h),

                    // Form Fields
                    _buildLabel("Services Name"),
                    _buildInputField(hint: "Ada's Deep Cleanse Avocado Clay Mask"),

                    SizedBox(height: 15.h),
                    _buildLabel("Services Price"),
                    _buildInputField(hint: "\$120"),

                    SizedBox(height: 15.h),
                    _buildLabel("Services Discount Price"),
                    _buildInputField(hint: "12 %"),

                    SizedBox(height: 15.h),
                    _buildLabel("Description (optional)"),
                    _buildInputField(hint: "", isLarge: true),

                    SizedBox(height: 30.h),

                    // Date & Time Section
                    CustomText(
                      text: "Services Data & Time",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1D3826),
                    ),
                    SizedBox(height: 15.h),

                    // Calendar Container
                    _buildCalendarSection(),

                    SizedBox(height: 20.h),

                    // Time Picker Row
                    _buildTimePickerRow(),

                    SizedBox(height: 40.h),

                    // Update Button
                    CustomButton(
                      text: "Update Services",
                      onTap: () {
                        // Update Logic
                      },
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180.h,
      backgroundColor: const Color(0xFF9BB575), // Moss Green header
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: CustomAppBar(title: "",showBackButton: true,bgColor: Colors.transparent,),

      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: CustomNetworkImage(
            imageUrl: AppAssets.appLogo, // Use your TNP logo
            height: 60.h,
            width: 140.w,
          ),
        ),
      ),
    );
  }

  Widget _buildServiceImage() {
    return Container(
      height: 160.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: const DecorationImage(
          image: NetworkImage("https://images.pexels.com/photos/3616991/pexels-photo-3616991.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: CircleAvatar(
          backgroundColor: const Color(0xFF1D3826),
          radius: 20.r,
          child: Icon(Icons.file_upload_outlined, color: Colors.white, size: 22.sp),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomText(text: text, fontSize: 14.sp, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildInputField({required String hint, bool isLarge = false}) {
    return Container(
      height: isLarge ? 100.h : 45.h,
      decoration: BoxDecoration(
        color: const Color(0xFF9BB575).withOpacity(0.7), // Moss green opacity
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: TextField(
        maxLines: isLarge ? 5 : 1,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white, fontSize: 13.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: isLarge ? 10.h : 0),
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.geryColor.withOpacity(0.1)),
      ),
      child: TableCalendar(
        availableGestures: AvailableGestures.horizontalSwipe,
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.primaryDark),
        ),
        selectedDayPredicate: (day) => _selectedDates.contains(DateTime(day.year, day.month, day.day)),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
            DateTime dayOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

            if (applyToFullYear) {
              // --- FULL YEAR LOGIC ---
              int targetWeekday = dayOnly.weekday;
              DateTime start = DateTime.now();

              // Determine if we are adding or removing based on the clicked day
              bool isAdding = !_selectedDates.contains(dayOnly);

              for (int i = 0; i <= 365; i++) {
                DateTime runner = start.add(Duration(days: i));
                DateTime runnerDay = DateTime(runner.year, runner.month, runner.day);

                if (runnerDay.weekday == targetWeekday) {
                  if (isAdding) {
                    _selectedDates.add(runnerDay);
                  } else {
                    _selectedDates.remove(runnerDay);
                  }
                }
              }
            } else {
              // --- MULTI-SELECT LOGIC ---
              if (_selectedDates.contains(dayOnly)) {
                _selectedDates.remove(dayOnly);
              } else {
                _selectedDates.add(dayOnly);
              }
            }
          });
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(color: Color(0XFF1D3826), shape: BoxShape.circle),
          selectedTextStyle: const TextStyle(color: Colors.white),
          todayDecoration: BoxDecoration(color: const Color(0XFF627E4C).withOpacity(0.2), shape: BoxShape.circle),
          todayTextStyle: const TextStyle(color: Color(0XFF1D3826), fontWeight: FontWeight.bold),
          defaultTextStyle: const TextStyle(color: Colors.black87),
          weekendTextStyle: const TextStyle(color: Colors.redAccent),
          outsideTextStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildTimePickerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _pickTime(true),
          child: _buildTimeBox(
            startTime.hourOfPeriod == 0 ? "12" : startTime.hourOfPeriod.toString().padLeft(2, '0'),
            startTime.minute.toString().padLeft(2, '0'),
            startTime.period == DayPeriod.am ? "AM" : "PM",
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: CustomText(text: "to", color: AppColors.geryColor, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () => _pickTime(false),
          child: _buildTimeBox(
            endTime.hourOfPeriod == 0 ? "12" : endTime.hourOfPeriod.toString().padLeft(2, '0'),
            endTime.minute.toString().padLeft(2, '0'),
            endTime.period == DayPeriod.am ? "AM" : "PM",
          ),
        ),
      ],
    );
  }

  Future<void> _pickTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime : endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.secondaryVariant,
              onPrimary: AppColors.white,
              onSurface: AppColors.primaryDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) startTime = picked; else endTime = picked;
      });
    }
  }


  Widget _buildTimeBox(String hour, String minute, String period) {
    return Row(
      children: [
        _timeInputField(hour),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: CustomText(text: ":", fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryDark),
        ),
        _timeInputField(minute),
        SizedBox(width: 8.w),
        Column(
          children: [
            CustomText(
                text: "AM",
                fontSize: 10.sp,
                color: period == "AM" ? AppColors.secondaryVariant : AppColors.geryColor,
                fontWeight: period == "AM" ? FontWeight.bold : FontWeight.normal
            ),
            CustomText(
                text: "PM",
                fontSize: 10.sp,
                color: period == "PM" ? AppColors.secondaryVariant : AppColors.geryColor,
                fontWeight: period == "PM" ? FontWeight.bold : FontWeight.normal
            ),
          ],
        )
      ],
    );
  }

  Widget _timeInputField(String value) {
    return Container(
      width: 50.w,
      height: 40.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.geryColor.withOpacity(0.3)),
      ),
      child: CustomText(text: value, color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16.sp),
    );
  }


}