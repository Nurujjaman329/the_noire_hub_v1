import 'package:get/get.dart';
import '../../../../../core/api/api_exception.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../data/order_full_fillment_post_body.dart';
import '../../data/order_full_fillment_response_model.dart';
import '../../data/order_full_fillment_service.dart';

class OrderFullFillmentController extends GetxController {
  final OrderFullFillmentService _service;
  OrderFullFillmentController(this._service);

  var isLoading = false.obs;
  var isSaving = false.obs;

  // Observable to hold the fetched data
  var fulfillmentData = Rxn<GetOrderFulfillmentAttributes>();

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  /// GET: Fetch current settings
  Future<void> fetchSettings() async {
    isLoading.value = true;
    try {
      final response = await _service.getFulfillmentSettings();
      fulfillmentData.value = response.data.attributes;
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isLoading.value = false;
    }
  }

  /// POST: Save updated settings
  Future<void> updateSettings(OrderFullFillmentPostBody body) async {
    isSaving.value = true;
    try {
      final success = await _service.saveFulfillmentSettings(body);

      if (success) {
        AppSnackbar.success("Fulfillment settings updated successfully!");
        // Optionally refresh data
        await fetchSettings();
      }
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isSaving.value = false;
    }
  }
}