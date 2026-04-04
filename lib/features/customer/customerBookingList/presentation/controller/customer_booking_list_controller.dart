

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../data/customer_booking_list_response_model.dart';
import '../../data/customer_booking_list_service.dart';

class CustomerBookingListController extends GetxController {
  final CustomerBookingListService _service;
  CustomerBookingListController(this._service);

  var selectedTab = "Complete".obs;
  var isLoading = false.obs;
  var bookings = <BookingDoc>[].obs;
  var isCanceling = false.obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var isUpdatingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  // Map UI names to API names
  String _mapTabToStatus(String tab) {
    switch (tab) {
      case "Pending": return "pending";
      case "In Progress": return "in-progress";
      case "Complete": return "completed";
      case "Canceled": return "cancelled";
      default: return "completed";
    }
  }

  void changeTab(String value) {
    if (selectedTab.value != value) {
      selectedTab.value = value;
      bookings.clear(); // Clear list so loader shows for new tab
      fetchBookings(page: 1);
    }
  }

  Future<void> fetchBookings({int page = 1}) async {
    isLoading.value = true;
    try {
      final response = await _service.getCustomerBookings(
        page: page,
        status: _mapTabToStatus(selectedTab.value), // Passing status to API
      );

      if (response.data?.attributes != null) {
        final attr = response.data!.attributes!;
        if (page == 1) {
          bookings.assignAll(attr.docs);
        } else {
          bookings.addAll(attr.docs);
        }
        currentPage.value = attr.page;
        totalPages.value = attr.totalPages;
      }
    } catch (e) {
      debugPrint("Controller Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> cancelBooking(String bookingId, String reason) async {
    isCanceling.value = true;
    try {
      final success = await _service.cancelBooking(
        bookingId: bookingId,
        reason: reason,
      );

      if (success) {
        Get.snackbar(
            "Success",
            "Booking cancelled successfully",
            backgroundColor: const Color(0xFF3F592B).withValues(alpha:0.7),
            colorText: Colors.white
        );
        // Refresh the current list to reflect changes
        onRefresh();
      }
    } catch (e) {
      Get.snackbar(
          "Error",
          "Failed to cancel booking. Please try again.",
          backgroundColor: Colors.red.withValues(alpha:0.7),
          colorText: Colors.white
      );
    } finally {
      isCanceling.value = false;
    }
  }


  Future<void> completeBooking(String bookingId) async {
    isUpdatingStatus.value = true;
    try {
      final success = await _service.updateBookingStatus(
        bookingId: bookingId,
        status: "completed",
      );

      if (success) {
        Get.snackbar(
          "Success",
          "Booking marked as completed!",
          backgroundColor: const Color(0xFF1D3826),
          colorText: Colors.white,
        );
        // Refresh the list to move the item to the "Complete" tab
        onRefresh();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update status. Please try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isUpdatingStatus.value = false;
    }
  }

  Future<void> onRefresh() async => await fetchBookings(page: 1);


  String getCancellationNotice(BookingDoc booking) {
    // 1. Check if it's a Service or a Product
    // Rule: If service object exists, it's a service cancellation.
    // Otherwise, if it has bookingItems but no service, treat as product.
    final isService = booking.service != null;

    if (isService) {
      if (booking.appointmentDate == null) return "Are you sure you want to cancel this service?";

      final now = DateTime.now();
      // Normalize dates to midnight for accurate day difference
      final today = DateTime(now.year, now.month, now.day);
      final appointment = DateTime(
          booking.appointmentDate!.year,
          booking.appointmentDate!.month,
          booking.appointmentDate!.day
      );

      final differenceInDays = appointment.difference(today).inDays;

      if (differenceInDays > 3) {
        return "Notice: Cancellation is free of charge (> 3 days).";
      } else if (differenceInDays == 3) {
        return "Notice: A 30% cancellation charge applies (3 days remaining).";
      } else if (differenceInDays == 2) {
        return "Notice: A 50% cancellation charge applies (2 days remaining).";
      } else if (differenceInDays == 1) {
        return "Notice: A 70% cancellation charge applies (1 day remaining).";
      } else {
        return "Notice: A 90% cancellation charge applies (Day of service).";
      }
    } else {
      // 2. Product Cancellation Logic
      if (booking.status.toLowerCase() == "completed") {
        return "Notice: Once order is completed, a cancellation charge of 10% applies.";
      }
      return "Are you sure you want to cancel this order?";
    }
  }

}