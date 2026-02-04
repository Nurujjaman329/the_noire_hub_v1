

import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/gmail_verification_service.dart';
import '../controller/gmail_verification_controller.dart';

class GmailVerificationBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Find the existing ApiClient and pass it to the service
    Get.lazyPut<GmailVerificationService>(() => GmailVerificationService(Get.find<ApiClient>()));

    // 2. Pass the service to the controller
    Get.lazyPut<GmailVerificationController>(() => GmailVerificationController(Get.find<GmailVerificationService>()));
  }
}