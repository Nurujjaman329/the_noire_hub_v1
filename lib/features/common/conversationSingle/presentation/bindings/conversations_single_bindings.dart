import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/conversations_single_service.dart';
import '../controller/conversations_single_controller.dart';

class ConversationsSingleBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationsSingleService>(
      () => ConversationsSingleService(Get.find<ApiClient>()),
    );

    Get.lazyPut<ConversationsSingleController>(
      () => ConversationsSingleController(Get.find<ConversationsSingleService>()),
    );
  }
}
