import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/edit_profile_service.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileService(Get.find<ApiClient>()));

    Get.lazyPut<EditProfileController>(
          () => EditProfileController(Get.find<EditProfileService>()),

    );
  }
}