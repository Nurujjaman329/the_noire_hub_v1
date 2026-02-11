import 'package:get/get.dart';
import '../../../../../core/api/api_client.dart';
import '../../data/order_full_fillment_service.dart';
import '../controller/order_full_fillment_controller.dart';

class OrderFullFillmentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderFullFillmentService(Get.find<ApiClient>()));
    Get.lazyPut(() => OrderFullFillmentController(Get.find<OrderFullFillmentService>()));
  }
}