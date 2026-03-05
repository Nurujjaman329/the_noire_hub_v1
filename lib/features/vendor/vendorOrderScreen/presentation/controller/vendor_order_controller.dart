import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/vendor_order_response_model.dart';
import '../../data/vendor_order_service.dart';


class VendorOrderController extends GetxController {
  final VendorOrderService _service;
  VendorOrderController(this._service);

  // --- Observable States ---
  // Defaulting to "Pending" to match the first tab
  var selectedTab = "Pending".obs;
  var isLoading = false.obs;
  var isCanceling = false.obs;
  var orders = <VendorOrderDoc>[].obs;

  // --- Pagination ---
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  /// Updated mapping to match your specific status strings:
  /// "pending", "in-progress", "completed", "cancelled"
  String _mapTabToStatus(String tab) {
    switch (tab) {
      case "Pending":     return "pending";
      case "In Progress": return "in-progress";
      case "Completed":   return "completed";
      case "Canceled":    return "cancelled"; // Matches double 'l' in your request
      default:            return "pending";
    }
  }

  /// Updates the UI state and triggers a fresh API call
  void changeTab(String value) {
    if (selectedTab.value != value) {
      selectedTab.value = value;
      orders.clear();
      currentPage.value = 1;
      fetchOrders(page: 1);
    }
  }

  /// Fetches orders using the updated status mapping
  Future<void> fetchOrders({int page = 1}) async {
    if (page == 1) isLoading.value = true;

    try {
      final response = await _service.getCustomerOrders(
        page: page,
        status: _mapTabToStatus(selectedTab.value),
      );

      if (response.data?.attributes != null) {
        final attr = response.data!.attributes!;
        if (page == 1) {
          orders.assignAll(attr.docs);
        } else {
          orders.addAll(attr.docs);
        }
        currentPage.value = attr.page;
        totalPages.value = attr.totalPages;
      }
    } catch (e) {
      // debugPrint is already implemented in your Service,
      // but we keep this here for controller-specific issues.
      debugPrint("Order Controller Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleCancel(String id, String reason) async {
    isCanceling.value = true;
    bool success = await _service.cancelOrder(orderId: id, reason: reason);
    isCanceling.value = false;

    if (success) {
      onRefresh(); // Refresh the list to move order to 'Canceled' tab
    }
  }

  /// Pull-to-refresh logic
  Future<void> onRefresh() async => await fetchOrders(page: 1);

  /// Infinite scroll / Pagination logic
  void loadMore() {
    if (currentPage.value < totalPages.value && !isLoading.value) {
      fetchOrders(page: currentPage.value + 1);
    }
  }
}