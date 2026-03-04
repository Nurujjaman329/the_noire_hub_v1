
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../data/service_booking_details_response_model.dart';
import '../controller/service_booking_details_controller.dart';

class ServiceBookingScreen extends StatelessWidget {
  const ServiceBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceBookingDetailsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF1D3826)),
          );
        }

        final attr = controller.serviceAttributes.value;
        if (attr == null) {
          return const Center(child: CustomText(text: "No details found"));
        }

        final String title = attr.name;
        final String imageUrl = attr.images.isNotEmpty
            ? "${ApiConstants.baseImageUrl}${attr.images.first}"
            : "https://via.placeholder.com/300";

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(
                        imageUrl,
                        title,
                        attr.price.toDouble(),
                        attr.discountedPrice.toDouble(),
                        attr.description
                    ),

                    const Divider(thickness: 3, color: Color(0xFFC4C99A)),

                    // DYNAMIC MULTI-SELECT VARIANTS
                    ...attr.variants.map((variant) {
                      return _buildListSelectionSection(
                        variant.id,
                        variant.variantName,
                        variant.description,
                        variant.subVariants,
                        controller,
                      );
                    }),

                    // CALENDAR SECTION
                    _buildCalendarSection(attr.availableDates),

                    // WORKING HOURS SECTION
                    _buildTimePickerSection(attr.workingHours),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
            // BOTTOM BOOKING BUTTON
            _buildBottomButton(controller),
          ],
        );
      }),
    );
  }

  // --- UI Helpers ---

  Widget _buildHeader(String img, String title, double originalPrice, double offerPrice, String desc) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: img,
          height: 280.h,
          width: double.infinity,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            height: 280.h,
            child: const Icon(Icons.image_not_supported),
          ),
        ),
        Positioned(
          top: 50.h, left: 20.w,
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
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            children: [
              CustomText(text: title, fontSize: 24.sp, fontWeight: FontWeight.bold),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$${originalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  CustomText(
                    text: "\$${offerPrice.toStringAsFixed(2)}",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D3826),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              CustomText(text: desc, fontSize: 12.sp, color: Colors.black54, textAlign: TextAlign.center),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListSelectionSection(
      String variantId,
      String title,
      String sub,
      List<SubVariant> options,
      ServiceBookingDetailsController controller,
      ) {
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
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 11.sp, color: Colors.black54),
                )
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF1F4D3)),
        Column(
          children: options.map((opt) {
            bool isSelected = controller.isSubVariantSelected(opt.id);

            return Column(
              children: [
                ListTile(
                  onTap: () => controller.toggleSubVariant(variantId, opt.id),
                  contentPadding: EdgeInsets.symmetric(horizontal: 25.w),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: opt.name,
                        fontSize: 14.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? const Color(0xFF2D3E2F) : Colors.black,
                      ),
                      CustomText(text: "+\$${opt.price}", fontSize: 12.sp, color: Colors.grey),
                    ],
                  ),
                  trailing: Icon(
                    isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                    color: isSelected ? const Color(0xFF2D3E2F) : Colors.grey,
                    size: 24.sp,
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

  Widget _buildCalendarSection(List<String> apiDates) {
    final controller = Get.find<ServiceBookingDetailsController>();
    final List<DateTime> availableDateTimes = apiDates.map((d) => DateTime.parse(d)).toList();

    return Padding(
      padding: EdgeInsets.fromLTRB(25.w, 25.h, 25.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "Available Dates", fontWeight: FontWeight.bold, fontSize: 18.sp),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                        text: controller.selectedDate.value != null
                            ? "${_getMonthName(controller.selectedDate.value!.month)} ${controller.selectedDate.value!.year}"
                            : (availableDateTimes.isNotEmpty
                            ? "${_getMonthName(availableDateTimes.first.month)} ${availableDateTimes.first.year}"
                            : "Select Date"),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp
                    ),
                    const Icon(Icons.calendar_today, size: 14),
                  ],
                ),
                SizedBox(height: 15.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 31,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    int dayNumber = index + 1;
                    DateTime? matchingDate;
                    try {
                      matchingDate = availableDateTimes.firstWhere((dt) => dt.day == dayNumber);
                    } catch (_) { matchingDate = null; }

                    bool isAvailable = matchingDate != null;
                    bool isSelected = controller.selectedDate.value?.day == dayNumber;

                    return GestureDetector(
                      onTap: isAvailable ? () => controller.updateDate(matchingDate!) : null,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFF2D3E2F)
                              : (isAvailable ? const Color(0xFFC4C99A).withValues(alpha:0.3) : Colors.transparent),
                          border: isAvailable ? Border.all(color: const Color(0xFF2D3E2F), width: 0.5) : null,
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          text: dayNumber.toString(),
                          fontSize: 12.sp,
                          color: isSelected ? Colors.white : (isAvailable ? Colors.black : Colors.grey[300]),
                          fontWeight: isSelected || isAvailable ? FontWeight.bold : FontWeight.normal,
                        ),
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

  Widget _buildTimePickerSection(WorkingHoursDetails? hours) {
    final controller = Get.find<ServiceBookingDetailsController>();
    String displayHours = (hours != null) ? "${hours.startTime} - ${hours.endTime}" : "Not Available";

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "Working Hours", fontWeight: FontWeight.bold, fontSize: 16.sp),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () async {
              if (hours == null) return;
              TimeOfDay? picked = await showTimePicker(
                context: Get.context!,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                if (controller.isTimeWithinRange(picked, hours)) {
                  controller.updateTime(picked.format(Get.context!));
                } else {
                  Get.snackbar("Closed", "Please select between ${hours.startTime} and ${hours.endTime}",
                      backgroundColor: Colors.redAccent, colorText: Colors.white);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFC4C99A)),
                borderRadius: BorderRadius.circular(25.r),
                color: const Color(0xFFF1F4D3).withValues(alpha:0.2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 20, color: Color(0xFF2D3E2F)),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: displayHours, fontSize: 12.sp, color: Colors.black54),
                      Obx(() => CustomText(
                          text: controller.selectedTime.value.isEmpty ? "Select Time" : controller.selectedTime.value,
                          fontWeight: FontWeight.bold, fontSize: 14.sp
                      )),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Color(0xFF2D3E2F)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(ServiceBookingDetailsController controller) {
    return Container(
      padding: EdgeInsets.fromLTRB(25.w, 10.h, 25.w, 35.h),
      color: Colors.white,
      child: Obx(() {
        bool hasVariants = controller.selectedBookingItems.isNotEmpty;

        return CustomButton(
          text: "Book | \$${controller.currentPrice.toStringAsFixed(2)}",
          onTap: () {
            if (controller.selectedDate.value == null || controller.selectedTime.value.isEmpty) {
              Get.snackbar("Required", "Please select a date and time",
                  backgroundColor: Colors.orange, colorText: Colors.white);
              return;
            }

            List<Map<String, dynamic>> displayItems = [];
            for (var bookingItem in controller.selectedBookingItems) {
              var variant = controller.serviceAttributes.value!.variants
                  .firstWhere((v) => v.id == bookingItem['variantId']);
              for (var subId in (bookingItem['subVariantIds'] as List)) {
                var subVariant = variant.subVariants.firstWhere((sv) => sv.id == subId);
                displayItems.add({
                  'name': "${variant.variantName}: ${subVariant.name}",
                  'price': subVariant.price.toDouble(),
                });
              }
            }

            Get.toNamed(RouteConstants.customerConfirmBookings, arguments: {
              'serviceId': controller.serviceAttributes.value?.id,
              'title': controller.serviceAttributes.value?.name,
              'img': "${ApiConstants.baseImageUrl}${controller.serviceAttributes.value?.images.first}",
              'bookingItems': controller.selectedBookingItems,
              'displayItems': displayItems,
              // If variants are chosen, the "Main Price" row in confirmation should be 0 or Hidden
              'basePrice': hasVariants ? 0.0 : controller.serviceAttributes.value?.discountedPrice,
              'date': controller.selectedDate.value.toString().split(' ')[0],
              'time': controller.selectedTime.value,
              'price': controller.currentPrice,
            });
          },
          textColor: const Color(0XFFF1F0B2),
          fontSize: 16.sp,
        );
      }),
    );
  }

  String _getMonthName(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }
}