
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../common/conversations/data/conversation_list_service.dart';
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
                    _buildTimeSlotSection(attr.workingSlots),

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
        Positioned(
          top: 50.h, right: 20.w,
          child: GestureDetector(
            onTap: () async {
              final controller = Get.find<ServiceBookingDetailsController>();
              final attr = controller.serviceAttributes.value;
              final beauticianId = attr?.beautician?.id ?? '';
              final serviceId = attr?.id ?? '';
              if (beauticianId.isEmpty || serviceId.isEmpty) return;
              try {
                Get.dialog(
                  const Center(child: CircularProgressIndicator(color: Colors.white)),
                  barrierDismissible: false,
                );
                final service = ConversationListService(Get.find<ApiClient>());
                final conv = await service.createConversation(
                  receiverId: beauticianId,
                  contextType: 'service',
                  contextId: serviceId,
                  contextModel: 'Service',
                );
                if (Get.isDialogOpen == true) Get.back();
                if (conv != null) {
                  Get.toNamed(
                    RouteConstants.singleConversationScreen,
                    arguments: {'conversationId': conv.id},
                  );
                }
              } catch (e) {
                if (Get.isDialogOpen == true) Get.back();
                Get.snackbar('Error', 'Could not start conversation',
                    backgroundColor: Colors.redAccent, colorText: Colors.white);
              }
            },
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha:0.5),
              child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
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

  Widget _buildTimeSlotSection(List<WorkingSlot> slots) {
    final controller = Get.find<ServiceBookingDetailsController>();

    if (slots.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        child: CustomText(
          text: "No Time Slots Available",
          fontSize: 14.sp,
          color: Colors.grey,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Available Time Slots",
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
          SizedBox(height: 15.h),

          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: slots.map((slot) {
              final slotText = "${slot.startTime} - ${slot.endTime}";

              return Obx(() {
                bool isSelected = controller.selectedTime.value == slotText;

                return GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      controller.updateTime(""); // deselect
                    } else {
                      controller.updateTime(slotText); // select
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2D3E2F)
                          : const Color(0xFFF1F4D3).withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xFFC4C99A),
                      ),
                    ),
                    child: CustomText(
                      text: slotText,
                      fontSize: 12.sp,
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              });
            }).toList(),
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
              // Always show main service amount; length/variants are added on top
              'basePrice': controller.serviceAttributes.value?.discountedPrice,
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