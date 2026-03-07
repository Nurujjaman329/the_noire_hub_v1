import 'package:flutter/material.dart';
import 'package:the_noire_hub_v1/features/common/walletScreen/data/withdraw_history_response_model.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import 'wallet_info_response_model.dart'; // Ensure this import is correct

class WalletInfoService {
  final ApiClient _apiClient;
  WalletInfoService(this._apiClient);

  /// GET: Fetch Wallet Information
  Future<WalletInfoResponseModel> getWalletInfo() async {
    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [GET] Request to: ${ApiConstants.wallet}');

    try {
      final response = await _apiClient.get(
        ApiConstants.wallet,
      );

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [GET] Success: ${ApiConstants.wallet}');
      debugPrint('Response Data: ${response.data}');

      return WalletInfoResponseModel.fromJson(response.data);
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint('❌ [GET] Error at: ${ApiConstants.wallet}');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }

  /// GET: Fetch Withdrawal History
  Future<WithdrawHistoryResponseModel> getWithdrawHistory({
    int page = 1,
    int limit = 10,
  }) async {

    final url = "${ApiConstants.withdrawHistory}?page=$page&limit=$limit";

    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [GET] Request to: $url');

    try {
      final response = await _apiClient.get(url);

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [GET] Success: $url');
      debugPrint('Response Data: ${response.data}');

      return WithdrawHistoryResponseModel.fromJson(response.data);
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint('❌ [GET] Error at: $url');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }

  /// POST: Withdraw Money
  Future<bool> withdrawAmount({required double amount}) async {
    final Map<String, dynamic> body = {
      "amount": amount,
    };

    // --- DEBUG PRINT: REQUEST ---
    debugPrint('🚀 [POST] Request to: ${ApiConstants.walletWithDraw}');
    debugPrint('Request Body: $body');

    try {
      final response = await _apiClient.postJson(
        ApiConstants.walletWithDraw,
        data: body,
      );

      // --- DEBUG PRINT: SUCCESS ---
      debugPrint('✅ [WITHDRAW] Success Status: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      // Return true if the request was successful
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // --- DEBUG PRINT: ERROR ---
      debugPrint('❌ [WITHDRAW] Error at: ${ApiConstants.walletWithDraw}');
      debugPrint('Error Details: $e');
      rethrow;
    }
  }
}