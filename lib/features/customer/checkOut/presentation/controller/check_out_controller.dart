import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../core/utils/mixins/map_search_mixin.dart';
import '../../../../../core/widgets/payment/stripe_payment_webview.dart';
import '../../../dealsPromos/data/promo_validate_response_model.dart';
import '../../data/check_out_service.dart';

class CheckOutController extends GetxController with MapSearchMixin {
  final CheckOutService _service;
  CheckOutController(this._service);

  var isPlacingOrder = false.obs;

  var selectedTipIndex = (-1).obs;
  var tipValue = 0.0.obs;
  var isFlatTip = true.obs;

  /// Validated promo for this checkout — Pay uses this code.
  final appliedPromo = Rxn<AppliedPromoResult>();

  @override
  void onInit() {
    super.onInit();
    appliedPromo.value = null;
    getCurrentLocation();
  }

  void setAppliedPromo(AppliedPromoResult? promo) {
    appliedPromo.value = promo;
  }

  void clearAppliedPromo() {
    appliedPromo.value = null;
  }

  Future<void> placeOrder({
    required String vendorId,
    required List<Map<String, dynamic>> items,
    required String deliveryMethod,
    required Map<String, dynamic> address,
    String? instructions,
    double? tip,
    String? promoCode,
  }) async {
    isPlacingOrder.value = true;

    final codeToSend = (promoCode != null && promoCode.trim().isNotEmpty)
        ? promoCode.trim()
        : appliedPromo.value?.code;

    final tipToSend = (tip != null && tip > 0) ? tip : null;

    final Map<String, dynamic> postBody = {
      "vendorId": vendorId,
      "items": items,
      "deliveryMethod": deliveryMethod,
      "deliveryAddress": address,
      if (instructions != null && instructions.trim().isNotEmpty)
        "deliveryInstructions": instructions.trim(),
      if (tipToSend != null) "tip": tipToSend,
      if (codeToSend != null && codeToSend.isNotEmpty) "promoCode": codeToSend,
    };

    debugPrint('📦 placeOrder promoCode=$codeToSend tip=$tipToSend');

    try {
      final result = await _service.createOrder(postBody);
      if (result != null) {
        String checkoutUrl = result['checkoutUrl'] ?? "";
        if (checkoutUrl.isNotEmpty) {
          Get.to(
            () => StripePaymentWebView(url: checkoutUrl),
            arguments: "checkout",
          );
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong while placing order");
    } finally {
      isPlacingOrder.value = false;
    }
  }

  double get calculatedTipAmount {
    if (tipValue.value <= 0) return 0.0;
    return tipValue.value;
  }

  void setTip(double value, bool isFlat, int index) {
    tipValue.value = value;
    isFlatTip.value = isFlat;
    selectedTipIndex.value = index;
  }
}
