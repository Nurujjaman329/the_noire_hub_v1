
import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/service/deals_promos_service.dart';
import '../controller/add_deals_promos_controller.dart';

class DealsPromosBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DealsPromosService(Get.find<ApiClient>()));
    Get.lazyPut(() => PromoCodeController(Get.find<DealsPromosService>()));
  }
}