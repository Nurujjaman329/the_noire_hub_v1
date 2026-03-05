import 'package:get/get.dart';
import '../../../../../core/utils/mixins/map_search_mixin.dart';
import '../../../../../core/widgets/payment/stripe_payment_webview.dart';
import '../../data/check_out_service.dart';

class CheckOutController extends GetxController with MapSearchMixin {
  final CheckOutService _service;
  CheckOutController(this._service);

  var isPlacingOrder = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Optionally get current location as soon as checkout starts
    getCurrentLocation();
  }

  Future<void> placeOrder({
    required String vendorId,
    required List<Map<String, dynamic>> items,
    required String deliveryMethod,
    required Map<String, dynamic> address, // We will now pass the dynamic address here
    String? instructions,
    double? tip,
    String? promoCode,
  }) async {
    isPlacingOrder.value = true;

    final Map<String, dynamic> postBody = {
      "vendorId": vendorId,
      "items": items,
      "deliveryMethod": deliveryMethod,
      "deliveryAddress": address,
      if (instructions != null) "deliveryInstructions": instructions,
      if (tip != null) "tip": tip,
      if (promoCode != null) "promoCode": promoCode,
    };

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
}