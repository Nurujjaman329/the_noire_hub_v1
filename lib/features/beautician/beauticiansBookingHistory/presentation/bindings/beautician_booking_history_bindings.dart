import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/beautician_booking_history_service.dart';
import '../controller/beautician_booking_history_controller.dart';

class BeauticianBookingHistoryBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<BeauticianBookingHistoryService>(
            () => BeauticianBookingHistoryService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<BeauticianBookingHistoryController>(
            () => BeauticianBookingHistoryController(Get.find<BeauticianBookingHistoryService>())
    );
  }
}