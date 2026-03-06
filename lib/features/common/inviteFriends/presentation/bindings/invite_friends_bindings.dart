import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/invite_friends_service.dart';
import '../controller/invite_friends_controller.dart';

class InviteFriendsBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<InviteFriendsService>(
            () => InviteFriendsService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<InviteController>(
            () => InviteController(Get.find<InviteFriendsService>())
    );
  }
}