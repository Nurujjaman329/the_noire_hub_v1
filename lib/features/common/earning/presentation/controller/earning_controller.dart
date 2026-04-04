import 'package:get/get.dart';
import '../../data/earning_response_model.dart';
import '../../data/earning_service.dart';
import 'package:flutter/material.dart';

class EarningsController extends GetxController {
  final EarningService _service;
  EarningsController(this._service);

  // Observables
  var isLoading = false.obs;
  var wallet = Wallet.empty().obs;
  var chartData = <ChartData>[].obs;
  var transactions = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEarnings();
  }

  Future<void> loadEarnings() async {
    try {
      isLoading.value = true;

      final response = await _service.getEarnings();

      // Update state with defaults if data is missing
      wallet.value = response.data.attributes.wallet;
      chartData.assignAll(response.data.attributes.chart);
      transactions.assignAll(response.data.attributes.recentTransactions);

      debugPrint('📊 Chart Data Points: ${chartData.length}');
    } catch (e) {
      debugPrint("Load Earnings Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Pull-to-refresh helper
  Future<void> onRefresh() async {
    await loadEarnings();
  }
}