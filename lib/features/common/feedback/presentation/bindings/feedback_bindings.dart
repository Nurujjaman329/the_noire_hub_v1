import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/feedback_service.dart';
import '../controller/feedback_controller.dart';

class FeedbackBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<FeedbackService>(
            () => FeedbackService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<FeedbackController>(
            () => FeedbackController(Get.find<FeedbackService>())
    );
  }
}