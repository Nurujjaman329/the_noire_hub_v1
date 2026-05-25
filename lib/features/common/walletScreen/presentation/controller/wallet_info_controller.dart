// lib/features/common/walletScreen/presentation/controller/wallet_info_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/payment/stripe_payment_webview.dart';
import '../../data/wallet_info_response_model.dart';
import '../../data/wallet_info_service.dart';
import '../../data/withdraw_history_response_model.dart';

class WalletInfoController extends GetxController {
  final WalletInfoService _service;
  WalletInfoController(this._service);

  // State Variables
  var isLoading = false.obs;
  var isWithdrawing = false.obs;

  // Observables for UI data
  var walletAttributes = WalletAttributes().obs;

  // Withdrawal history state
  var withdrawHistory = <WithdrawalItem>[].obs;
  var historyLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletInfo();
    fetchWithdrawHistory();
  }



  /// --- FETCH WALLET DATA ---
  Future<void> fetchWalletInfo() async {
    isLoading.value = true;
    try {
      final response = await _service.getWalletInfo();

      if (response.data?.attributes != null) {
        walletAttributes.value = response.data!.attributes!;
        debugPrint("✅ [CONTROLLER] Wallet Data Loaded: Balance ${walletAttributes.value.balance}");
      }
    } catch (e) {
      debugPrint("❌ [CONTROLLER] Fetch Wallet Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// --- FETCH WITHDRAW HISTORY ---
  Future<void> fetchWithdrawHistory({int page = 1}) async {
    historyLoading.value = true;

    try {
      final response = await _service.getWithdrawHistory(page: page);

      if (response.data?.attributes?.results != null) {
        withdrawHistory.value =
            response.data!.attributes!.results;

        debugPrint(
            "✅ [CONTROLLER] Withdraw History Loaded: ${withdrawHistory.length}");
      }
    } catch (e) {
      debugPrint("❌ [CONTROLLER] Withdraw History Error: $e");
    } finally {
      historyLoading.value = false;
    }
  }

  /// --- REQUEST WITHDRAWAL ---
  Future<void> requestWithdrawal(double amount) async {
    if (amount <= 0) {
      Get.snackbar(
          "Invalid Amount",
          "Please enter an amount greater than 0",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white
      );
      return;
    }

    isWithdrawing.value = true;
    try {
      final response = await _service.withdrawAmount(amount: amount);

      if (response.needsStripeSetup) {
        Get.snackbar(
          "Stripe Setup Required",
          response.message.isNotEmpty
              ? response.message
              : "Please connect your Stripe account to withdraw.",
          backgroundColor: const Color(0xFF3F592B),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        await Get.to(
          () => StripePaymentWebView(url: response.onboardingUrl!),
          arguments: 'stripe_onboarding',
        );

        await fetchWalletInfo();
        return;
      }

      Get.snackbar(
        "Success",
        response.message.isNotEmpty
            ? response.message
            : "Withdrawal request submitted successfully!",
        backgroundColor: const Color(0xFF3F592B),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      await fetchWalletInfo();
      await fetchWithdrawHistory();
    } catch (e) {
      debugPrint("❌ [CONTROLLER] Withdrawal Error: $e");
      Get.snackbar(
        "Error",
        "Failed to process withdrawal. Please try again.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isWithdrawing.value = false;
    }
  }

  /// --- REFRESH WALLET ---
  Future<void> onRefresh() async {
    await fetchWalletInfo();
    await fetchWithdrawHistory();
  }}