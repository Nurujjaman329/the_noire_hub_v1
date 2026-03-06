import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/customer_orders_response_model.dart';
import '../../data/customer_orders_service.dart';

class CustomerOrderController extends GetxController {
  final CustomerOrdersService _service;
  CustomerOrderController(this._service);

  /// --- Observable States ---
  var selectedTab = "Pending".obs;
  var isLoading = false.obs;
  var isCanceling = false.obs;

  var orders = <OrderDoc>[].obs;

  /// --- Pagination ---
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  /// Map tab text → API status
  String _mapTabToStatus(String tab) {
    switch (tab) {
      case "Pending":
        return "pending";
      case "In Progress":
        return "in-progress";
      case "Completed":
        return "completed";
      case "Canceled":
        return "cancelled";
      default:
        return "pending";
    }
  }

  /// Change tab
  void changeTab(String value) {
    if (selectedTab.value != value) {
      selectedTab.value = value;
      orders.clear();
      currentPage.value = 1;
      totalPages.value = 1;

      fetchOrders(page: 1);
    }
  }

  /// Fetch orders
  Future<void> fetchOrders({int page = 1}) async {
    try {
      if (page == 1) {
        isLoading.value = true;
      }

      final response = await _service.getCustomerOrders(
        page: page,
        status: _mapTabToStatus(selectedTab.value),
      );

      final attr = response.data?.attributes;

      if (attr != null) {
        if (page == 1) {
          orders.assignAll(attr.docs);
        } else {
          orders.addAll(attr.docs);
        }

        currentPage.value = attr.page;
        totalPages.value = attr.totalPages;
      }
    } catch (e) {
      debugPrint("Order Controller Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancel order
  Future<void> handleCancel(String id, String reason) async {
    try {
      isCanceling.value = true;

      bool success =
      await _service.cancelOrder(orderId: id, reason: reason);

      if (success) {
        await onRefresh();
      }
    } catch (e) {
      debugPrint("Cancel Order Error: $e");
    } finally {
      isCanceling.value = false;
    }
  }

  /// Pull to refresh
  Future<void> onRefresh() async {
    currentPage.value = 1;
    await fetchOrders(page: 1);
  }

  /// Load more (pagination)
  void loadMore() {
    if (!isLoading.value &&
        currentPage.value < totalPages.value) {
      fetchOrders(page: currentPage.value + 1);
    }
  }
}