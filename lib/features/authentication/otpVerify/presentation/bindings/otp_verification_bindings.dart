

import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/otp_verification_service.dart';
import '../controller/otp_verification_controller.dart';

class OtpVerificationBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Find the existing ApiClient and pass it to the service
    Get.lazyPut<OtpVerificationService>(() => OtpVerificationService(Get.find<ApiClient>()));

    // 2. Pass the service to the controller
    Get.lazyPut<OtpVerificationController>(() => OtpVerificationController(Get.find<OtpVerificationService>()));
  }
}