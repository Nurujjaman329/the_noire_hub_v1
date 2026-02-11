import 'package:get/get.dart';

import '../../../../../core/api/api_client.dart';
import '../../data/business_document_service.dart';
import '../controller/business_document_controller.dart';


class BusinessDocumentsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessDocumentService(Get.find<ApiClient>()));
    Get.lazyPut(() => BusinessDocumentController(Get.find<BusinessDocumentService>()));
  }
}