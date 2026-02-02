// import 'package:get/get.dart';
// import '../../features/customerServices/data/repositories/home_repository.dart';
// import '../../features/customerServices/domain/services/home_service.dart';
// import '../../features/customerServices/presentation/controllers/home_controller.dart';
// import '../services/api_service.dart';
// import '../services/cache_service.dart';
// import '../services/connectivity_service.dart';
//
//
// class DependencyInjection {
//   // Private constructor to prevent instantiation
//   DependencyInjection._();
//
//   static Future<void> init() async {
//     // Core Services (Singletons)
//     Get.lazyPut<CacheService>(() => CacheService(), fenix: true);
//     Get.lazyPut<ApiService>(() => ApiService(), fenix: true);
//     Get.lazyPut<ConnectivityService>(() => ConnectivityService(), fenix: true);
//
//     // Repositories
//     Get.lazyPut<HomeRepository>(
//       () => HomeRepository(
//         apiService: Get.find<ApiService>(),
//         cacheService: Get.find<CacheService>(),
//         connectivityService: Get.find<ConnectivityService>(),
//       ),
//       fenix: true,
//     );
//
//     // Domain Services
//     Get.lazyPut<HomeService>(
//       () => HomeService(
//         repository: Get.find<HomeRepository>(),
//         connectivityService: Get.find<ConnectivityService>(),
//       ),
//       fenix: true,
//     );
//
//     // Controllers
//     Get.lazyPut<HomeController>(
//       () => HomeController(
//         homeService: Get.find<HomeService>(),
//         repository: Get.find<HomeRepository>(),
//         connectivityService: Get.find<ConnectivityService>(),
//       ),
//     );
//   }
//
//   static void clear() {
//     Get.deleteAll(force: true);
//   }
// }