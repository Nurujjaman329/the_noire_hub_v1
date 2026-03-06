import 'package:get/get.dart';
import '../../../../../core/api/api_client.dart';
import '../../data/check_out_service.dart';
import '../controller/check_out_controller.dart';


class CheckOutBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<CheckOutService>(
            () => CheckOutService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<CheckOutController>(
            () => CheckOutController(Get.find<CheckOutService>())
    );
  }
}