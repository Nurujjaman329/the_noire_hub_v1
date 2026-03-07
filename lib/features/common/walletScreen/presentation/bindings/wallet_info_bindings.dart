import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/wallet_info_service.dart';
import '../controller/wallet_info_controller.dart';

class WalletInfoBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Inject ApiClient into the Service
    Get.lazyPut<WalletInfoService>(
            () => WalletInfoService(Get.find<ApiClient>())
    );

    // 2. Inject Service into the Controller
    Get.lazyPut<WalletInfoController>(
            () => WalletInfoController(Get.find<WalletInfoService>())
    );
  }
}