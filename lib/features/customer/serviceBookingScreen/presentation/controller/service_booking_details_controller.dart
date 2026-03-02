import 'package:get/get.dart';
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
  var selectedVariantId = "".obs;
  var selectedSubVariantId = "".obs; // Start empty so nothing is pre-clicked
  var selectedDate = Rxn<DateTime>();
  var selectedTime = "".obs;
  var quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();

    String? serviceId;

    if (Get.arguments == null) {
      debugPrint("❌ No arguments passed to ServiceBookingDetailsController");
      return;
    }

    if (Get.arguments is String) {
      serviceId = Get.arguments as String;
    } else if (Get.arguments is CustomerService) {
      serviceId = (Get.arguments as CustomerService).id;
    }

    if (serviceId != null && serviceId.isNotEmpty) {
      fetchServiceDetails(serviceId);
    }
  }

  Future<void> fetchServiceDetails(String id) async {
    isLoading.value = true;
    try {
      final response = await _service.getServiceDetails(id);
      if (response.data?.attributes != null) {
        serviceAttributes.value = response.data!.attributes;

        // Removed the auto-selection of variants here so
        // the user has to click them manually.
      }
    } catch (e) {
      Get.snackbar("Error", "Could not load service details");
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggles or selects a sub-variant.
  /// If the user clicks the same one again, it deselects it.
  void selectSubVariant(String id) {
    // If the id is empty (passed from UI null) or matches current selection, reset it
    if (id.isEmpty || selectedSubVariantId.value == id) {
      selectedSubVariantId.value = "";
    } else {
      selectedSubVariantId.value = id;
    }
  }

  /// Calculates dynamic price:
  /// Base (Offer Price) + Selected Sub-variant Addition
  double get currentPrice {
    if (serviceAttributes.value == null) return 0.0;

    double baseOfferPrice = serviceAttributes.value!.discountedPrice.toDouble();
    double extraCharge = 0.0;
    bool hasVariantSelected = selectedSubVariantId.value.isNotEmpty;

    if (hasVariantSelected) {
      for (var variant in serviceAttributes.value!.variants) {
        for (var subVariant in variant.subVariants) {
          if (subVariant.id == selectedSubVariantId.value) {
            extraCharge = subVariant.price.toDouble();
            break;
          }
        }
      }
    }

    // NEW LOGIC:
    // If a variant is selected, show only the variant price.
    // If no variant is selected, show the base offer price.
    double finalPrice = hasVariantSelected ? extraCharge : baseOfferPrice;

    return finalPrice * quantity.value;
  }


  /// Validates if the picked time is within working hours
  bool isTimeWithinRange(TimeOfDay picked, WorkingHoursDetails hours) {
    final int pickedMinutes = picked.hour * 60 + picked.minute;

    int getMinutes(String timeStr) {
      try {
        List<String> parts = timeStr.split(':');
        return int.parse(parts[0]) * 60 + int.parse(parts[1]);
      } catch (e) {
        return 0;
      }
    }

    int startMinutes = getMinutes(hours.startTime);
    int endMinutes = getMinutes(hours.endTime);

    return pickedMinutes >= startMinutes && pickedMinutes <= endMinutes;
  }

  void updateDate(DateTime date) => selectedDate.value = date;

  void updateTime(String time) => selectedTime.value = time;


}