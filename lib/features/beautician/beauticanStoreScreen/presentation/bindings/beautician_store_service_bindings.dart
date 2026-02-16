import 'package:get/get.dart';
import '../../../../../core/api/api_client.dart';
import '../../data/beautician_store_service.dart';
import '../controller/beautician_store_service_controller.dart';

class BeauticianStoreServiceBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject Service (passing existing ApiClient)
    Get.lazyPut(() => BeauticianStoreService(Get.find<ApiClient>()));

    // 2. Inject Controller
    Get.lazyPut(() => BeauticianStoreServiceController(Get.find<BeauticianStoreService>()));
  }
}