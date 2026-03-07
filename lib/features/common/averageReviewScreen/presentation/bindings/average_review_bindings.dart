import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/average_review_service.dart';
import '../controller/average_review_controller.dart';

class AverageReviewBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<AverageReviewService>(
            () => AverageReviewService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<AverageReviewController>(
            () => AverageReviewController(Get.find<AverageReviewService>())
    );
  }
}