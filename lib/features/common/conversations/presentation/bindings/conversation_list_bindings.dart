import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/conversation_list_service.dart';
import '../controller/conversation_list_controller.dart';

class ConversationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationListService>(
      () => ConversationListService(Get.find<ApiClient>()),
    );

    Get.lazyPut<ConversationController>(
      () => ConversationController(Get.find<ConversationListService>()),
    );
  }
}
