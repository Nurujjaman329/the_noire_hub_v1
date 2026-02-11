import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';


class VendorAvailabilitySection extends StatefulWidget {
  const VendorAvailabilitySection({super.key});

  @override
  State<VendorAvailabilitySection> createState() => _VendorAvailabilitySectionState();
}

class _VendorAvailabilitySectionState extends State<VendorAvailabilitySection> {
  final Set<DateTime> _selectedDates = {};
  DateTime _focusedDay = DateTime.now();
  bool applyToAll = false;
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);

  bool applyToFullYear = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF627E4C),
      // backgroundColor: AppColors.secondaryVariant, // Brand Olive Green
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CustomText(
                        text: "Braids By Mia",
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF1D3826),
                        // color: AppColors.primaryDark,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    CustomText(text: "Select Dates", fontSize: 22.sp, fontWeight: FontWeight.bold, color: Color(0XFF1D3826),),
                    CustomText(text: "What days are you available for bookings", fontSize: 12.sp, color: Color(0XFF627E4C)),

                    SizedBox(height: 20.h),
                    _buildCalendarSection(),

                    SizedBox(height: 30.h),

                    _buildOptionCheckbox(
                      title: "Set selected days as recurring within the year",
                      value: applyToFullYear,
                      onChanged: (val) => setState(() => applyToFullYear = val!),
                    ),

                    CustomText(text: "Working Hours", fontSize: 22.sp, fontWeight: FontWeight.bold, color: Color(0XFF1D3826),),
                    CustomText(text: "What hours are you available for bookings", fontSize: 12.sp, color: Color(0XFF627E4C)),

                    SizedBox(height: 20.h),
                    _buildApplyToAllCheckbox(),

                    SizedBox(height: 30.h),
                    _buildTimePickerRow(),

                    SizedBox(height: 50.h),

                    _buildFooterNavigation(),
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
      backgroundColor: Color(0XFF627E4C),
      // backgroundColor: AppColors.secondaryVariant,
      automaticallyImplyLeading: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: CircleAvatar(
                        radius: 18.r,
                        backgroundColor: Colors.black.withValues(alpha:0.2),
                        child: Icon(Icons.arrow_back_ios_new, color: AppColors.white, size: 16.sp),
                      ),
                    ),

                  ],
                ),
              ),
              const Spacer(),
              CustomNetworkImage(imageUrl: AppAssets.appLogo, height: 60.h, width: 150.w, fit: BoxFit.contain),
              const Spacer(),
              SizedBox(height: 30.h),
            ],
          ),
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
        border: Border.all(color: AppColors.geryColor.withValues(alpha:0.1)),
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
          todayDecoration: BoxDecoration(color: const Color(0XFF627E4C).withValues(alpha:0.2), shape: BoxShape.circle),
          todayTextStyle: const TextStyle(color: Color(0XFF1D3826), fontWeight: FontWeight.bold),
          defaultTextStyle: const TextStyle(color: Colors.black87),
          weekendTextStyle: const TextStyle(color: Colors.redAccent),
          outsideTextStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }


  Widget _buildApplyToAllCheckbox() {
    return GestureDetector(
      onTap: () {
        setState(() {
          applyToAll = !applyToAll;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Color(0XFF1D3826),
          // color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: applyToAll,
                activeColor: AppColors.secondaryVariant,
                checkColor: AppColors.white,
                side: BorderSide(color: AppColors.white, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                onChanged: (val) {
                  setState(() {
                    applyToAll = val!;
                  });
                },
              ),
            ),
            CustomText(
              text: "Apply to all selected dates",
              color: AppColors.white,
              fontSize: 12.sp,
              left: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCheckbox({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h), // Increased vertical padding for 2 lines
        decoration: BoxDecoration(
          color: const Color(0XFF1D3826),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max, // Ensures the row fills the container width
          crossAxisAlignment: CrossAxisAlignment.center, // Keeps checkbox aligned with text
          children: [
            Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: value,
                activeColor: AppColors.secondaryVariant,
                checkColor: AppColors.white,
                side: const BorderSide(color: Colors.white, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                onChanged: onChanged,
              ),
            ),
            SizedBox(width: 5.w),

            // --- THE FIX IS HERE ---
            Expanded(
              child: CustomText(
                text: title,
                color: Colors.white,
                fontSize: 12.sp,
                maxLines: 2, // Now this will correctly wrap to 2 lines
              ),
            ),
          ],
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
        border: Border.all(color: AppColors.geryColor.withValues(alpha:0.3)),
      ),
      child: CustomText(text: value, color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16.sp),
    );
  }

  Widget _buildFooterNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(onPressed: () => Get.back(), child: CustomText(text: "Back", color: Color(0XFFB5B475))),
        TextButton(
          onPressed: () {
            if (_selectedDates.isEmpty) {
              Get.snackbar("Notice", "Please select at least one date", backgroundColor: Colors.orangeAccent);
              return;
            }
            Get.snackbar("Success", "Availability Saved!", backgroundColor: AppColors.secondaryVariant, colorText: AppColors.white);
          },
          child: Row(
            children: [
              CustomText(text: "Continue", color: Color(0XFFB5B475), fontWeight: FontWeight.bold, fontSize: 14.sp),
              Icon(Icons.arrow_forward, color: AppColors.secondaryVariant, size: 16.sp),
            ],
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
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }
}