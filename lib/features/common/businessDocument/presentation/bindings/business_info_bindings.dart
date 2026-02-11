import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/businessInfo/business_info_service.dart';
import '../controller/businessInfo/business_info_controller.dart';

class BusinessInfoBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessInfoService(Get.find<ApiClient>()));
    Get.lazyPut(() => BusinessInfoController(Get.find<BusinessInfoService>()));
  }
}