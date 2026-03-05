import 'package:get/get.dart';
import 'package:the_noire_hub_v1/features/customer/customerServices/data/customer_service_book_service.dart';
import '../../features/beautician/beauticanStoreScreen/data/beautician_store_service.dart';
import '../../features/beautician/beauticanStoreScreen/presentation/controller/beautician_store_service_controller.dart';
import '../../features/customer/customerBookingList/data/customer_booking_list_service.dart';
import '../../features/customer/customerBookingList/presentation/controller/customer_booking_list_controller.dart';
import '../../features/customer/customerProducts/data/customer_products_service.dart';
import '../../features/customer/customerProducts/presentation/controller/customer_products_controller.dart';
import '../../features/customer/customerServices/presentation/controller/customer_service_controller.dart';
import '../../features/customer/multiVendorCartScreen/data/multi_vendor_cart_service.dart';
import '../../features/customer/multiVendorCartScreen/presentation/controller/multi_vendor_cart_controller.dart';
import '../../features/vendor/vendorOrderScreen/data/vendor_order_service.dart';
import '../../features/vendor/vendorOrderScreen/presentation/controller/vendor_order_controller.dart';
import '../api/api_client.dart';
import '../../features/authentication/login/data/login_service.dart';
import '../../features/authentication/login/presentation/controller/login_controller.dart';
import '../../features/common/category/data/category_service.dart';
import '../../features/common/category/presentation/controller/category_controller.dart';
import '../../features/common/subCategories/data/sub_categories_service.dart';
import '../../features/common/subCategories/presentation/controller/sub_categories_controller.dart';
import '../../features/vendor/vendorStoreScreen/data/vendor_products_service.dart';
import '../../features/vendor/vendorStoreScreen/presentation/controller/vendor_product_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core
    Get.put<ApiClient>(ApiClient(), permanent: true);

    // Auth
    Get.lazyPut<LoginService>(() => LoginService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(Get.find<LoginService>()), fenix: true);

    // Categories
    Get.lazyPut<CategoryService>(() => CategoryService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<CategoryController>(() => CategoryController(Get.find<CategoryService>()), fenix: true);

    // SubCategories
    Get.lazyPut<SubCategoryService>(() => SubCategoryService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<SubCategoryController>(() => SubCategoryController(Get.find<SubCategoryService>()), fenix: true);

    // Vendor Products
    Get.lazyPut<VendorProductList>(() => VendorProductList(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<VendorProductController>(() => VendorProductController(Get.find<VendorProductList>()), fenix: true);

    // Beauticians Services
    Get.lazyPut<BeauticianStoreService>(() => BeauticianStoreService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<BeauticianStoreServiceController>(() => BeauticianStoreServiceController(Get.find<BeauticianStoreService>()), fenix: true);

    // Customer Products
    Get.lazyPut<CustomerProductsService>(() => CustomerProductsService(Get.find<ApiClient>()));
    Get.lazyPut<CustomerProductsController>(() => CustomerProductsController(Get.find<CustomerProductsService>()));


    // Customer Services
    Get.lazyPut<CustomerServiceBookService>(() => CustomerServiceBookService(Get.find<ApiClient>()));
    Get.lazyPut<CustomerServiceController>(() => CustomerServiceController(Get.find<CustomerServiceBookService>()));

    // Customer Booking List
    Get.lazyPut<CustomerBookingListService>(() => CustomerBookingListService(Get.find<ApiClient>()));
    Get.lazyPut<CustomerBookingListController>(() => CustomerBookingListController(Get.find<CustomerBookingListService>()));

    // Customer Cart List
    Get.lazyPut<MultiVendorCartService>(() => MultiVendorCartService(Get.find<ApiClient>()));
    Get.lazyPut<MultiVendorCartController>(() => MultiVendorCartController(Get.find<MultiVendorCartService>()));

    // Customer Cart List
    Get.lazyPut<VendorOrderService>(() => VendorOrderService(Get.find<ApiClient>()));
    Get.lazyPut<VendorOrderController>(() => VendorOrderController(Get.find<VendorOrderService>()));

  }
}
