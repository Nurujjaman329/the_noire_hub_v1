import 'package:get/get.dart';
import '../../data/delete_account_service.dart';
import '../controller/delete_account_controller.dart';

class DeleteAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeleteAccountService>(
      () => DeleteAccountService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<DeleteAccountController>(
      () => DeleteAccountController(Get.find()),
      fenix: true,
    );
  }
}
