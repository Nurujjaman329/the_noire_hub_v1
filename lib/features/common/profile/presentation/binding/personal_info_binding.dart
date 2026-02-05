// import 'package:get/get.dart';
// import '../../../../../core/api/api_client.dart';
// import '../../data/profile_service.dart';
// import '../controller/personal_info_controller.dart';
//
// class ProfileBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => ProfileService(Get.find<ApiClient>()));
//
//     Get.lazyPut<ProfileController>(
//           () => ProfileController(Get.find<ProfileService>()),
//
//     );
//   }
// }