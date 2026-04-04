import 'package:get/get.dart';
import '../../../../../core/widgets/payment/stripe_payment_webview.dart';
import '../../../customerServices/data/customer_service_book_service.dart';
import '../../../customerServices/data/customer_services_response_model.dart';
import '../../data/service_booking_details_response_model.dart';
import 'package:flutter/material.dart';


class ServiceBookingDetailsController extends GetxController {
  final CustomerServiceBookService _service;
  ServiceBookingDetailsController(this._service);

  var isLoading = false.obs;
  var serviceAttributes = Rxn<ServiceDetailsAttributes>();

  // Selection States
  var selectedDate = Rxn<DateTime>();
  var selectedTime = "".obs;
  var quantity = 1.obs;

  // Store as [{"variantId": "...", "subVariantIds": ["id1", "id2"]}]
  var selectedBookingItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    String? serviceId;
    if (Get.arguments is String) {
      serviceId = Get.arguments as String;
    } else if (Get.arguments is CustomerService) {
      serviceId = (Get.arguments as CustomerService).id;
    }
    if (serviceId != null && serviceId.isNotEmpty) {
      fetchServiceDetails(serviceId);
    }
  }

  // --- API CALLS ---

  Future<void> fetchServiceDetails(String id) async {
    isLoading.value = true;
    try {
      final response = await _service.getServiceDetails(id);
      if (response.data?.attributes != null) {
        serviceAttributes.value = response.data!.attributes;
      }
    } catch (e) {
      Get.snackbar("Error", "Could not load service details",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  /// NEW: Finalize the booking
  Future<void> createBooking({
    required String serviceId,
    required List<Map<String, dynamic>> items,
    required String date,
    required String time,
  }) async {
    isLoading.value = true;
    try {
      final response = await _service.bookService(
        serviceId: serviceId,
        bookingItems: items,
        appointmentDate: date,
        appointmentTime: time,
      );

      // Extract checkoutUrl from the response structure you provided
      // data -> attributes -> checkoutUrl
      String? checkoutUrl = response['data']?['attributes']?['checkoutUrl'];

      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        // Navigate to WebView Screen
        Get.to(() => StripePaymentWebView(url: checkoutUrl));
      } else {
        Get.snackbar("Error", "Payment link not found");
      }

    } catch (e) {
      debugPrint("Booking Error: $e");
      Get.snackbar(
        "Booking Failed",
        "Something went wrong while creating your booking.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- SELECTION LOGIC ---

  void toggleSubVariant(String variantId, String subVariantId) {
    int index = selectedBookingItems.indexWhere((item) => item['variantId'] == variantId);

    if (index != -1) {
      List<String> subIds = List<String>.from(selectedBookingItems[index]['subVariantIds']);
      if (subIds.contains(subVariantId)) {
        subIds.remove(subVariantId);
      } else {
        subIds.add(subVariantId);
      }

      if (subIds.isEmpty) {
        selectedBookingItems.removeAt(index);
      } else {
        selectedBookingItems[index]['subVariantIds'] = subIds;
      }
    } else {
      selectedBookingItems.add({
        "variantId": variantId,
        "subVariantIds": [subVariantId]
      });
    }
    selectedBookingItems.refresh();
  }

  bool isSubVariantSelected(String subId) {
    return selectedBookingItems.any((item) => (item['subVariantIds'] as List).contains(subId));
  }

  double get currentPrice {
    if (serviceAttributes.value == null) return 0.0;

    // If user has NOT selected any variants, return the main discounted price
    if (selectedBookingItems.isEmpty) {
      return serviceAttributes.value!.discountedPrice.toDouble();
    }

    // If user HAS selected variants, calculate total of variants ONLY
    double variantTotal = 0.0;
    for (var selection in selectedBookingItems) {
      var variant = serviceAttributes.value!.variants.firstWhere((v) => v.id == selection['variantId']);
      for (var subId in (selection['subVariantIds'] as List)) {
        var subVariant = variant.subVariants.firstWhere((sv) => sv.id == subId);
        variantTotal += subVariant.price.toDouble();
      }
    }
    return variantTotal * quantity.value;
  }




  void updateDate(DateTime date) => selectedDate.value = date;
  void updateTime(String time) => selectedTime.value = time;
}