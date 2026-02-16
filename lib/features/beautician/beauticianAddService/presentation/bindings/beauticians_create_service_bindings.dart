import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/beauticians_create_service.dart';
import '../controller/beauticians_create_service_controller.dart';


class BeauticiansCreateServiceBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BeauticiansCreateService(Get.find<ApiClient>()));
    Get.lazyPut(() => BeauticiansCreateServiceController(Get.find<BeauticiansCreateService>()));
  }
}