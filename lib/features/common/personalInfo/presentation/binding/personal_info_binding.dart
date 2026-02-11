import 'package:get/get.dart';
import '../../../../../core/api/api_client.dart';
import '../../data/personal_info_service.dart';
import '../controller/personal_info_controller.dart';

class PersonalInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalInfoService(Get.find<ApiClient>()));

    Get.lazyPut<PersonalInfoController>(
          () => PersonalInfoController(Get.find<PersonalInfoService>()),

    );
  }
}