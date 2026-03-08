import 'package:get/get.dart';
import 'package:the_noire_hub_v1/core/constants/route_constants.dart';
import 'package:the_noire_hub_v1/features/authentication/gmailVerification/presentation/bindings/gmail_verification_bindings.dart';
import 'package:the_noire_hub_v1/features/authentication/registration/presentation/bindings/registration_bindings.dart';
import 'package:the_noire_hub_v1/features/authentication/resetPassword/presentation/bindings/reset_password_bindings.dart';
import 'package:the_noire_hub_v1/features/beautician/beauticianAddService/presentation/screen/beautician_add_service_screen.dart';
import 'package:the_noire_hub_v1/features/beautician/serviceDetailsScreen/presentation/bindings/service_details_bindings.dart';
import 'package:the_noire_hub_v1/features/common/averageReviewScreen/presentation/bindings/average_review_bindings.dart';
import 'package:the_noire_hub_v1/features/common/businessDocument/presentation/bindings/business_documents_bindings.dart';
import 'package:the_noire_hub_v1/features/common/changePassword/presentation/bindings/change_password_bindings.dart';
import 'package:the_noire_hub_v1/features/common/inviteFriends/presentation/bindings/invite_friends_bindings.dart';
import 'package:the_noire_hub_v1/features/common/walletScreen/presentation/bindings/wallet_info_bindings.dart';
import 'package:the_noire_hub_v1/features/customer/checkOut/presentation/bindings/check_out_bindings.dart';
import 'package:the_noire_hub_v1/features/customer/customerOrderScreen/presentation/bindings/customer_orders_bindings.dart';
import 'package:the_noire_hub_v1/features/customer/customerServices/presentation/bindings/customer_service_bindings.dart';
import 'package:the_noire_hub_v1/features/customer/dealsPromos/presentation/bindings/customer_deals_promos_bindings.dart';
import 'package:the_noire_hub_v1/features/customer/favourite/presentation/bindings/favorites_bindings.dart';
import 'package:the_noire_hub_v1/features/customer/productDetailsScreen/presentation/bindings/product_details_bindings.dart';
import 'package:the_noire_hub_v1/features/vendor/orderFullFillment/presentation/bindings/order_full_fillment_bindings.dart';
import 'package:the_noire_hub_v1/features/vendor/vendorAddProduct/presentation/screen/vendor_add_product_screen.dart';
import 'package:the_noire_hub_v1/features/vendor/vendorStoreScreen/presentation/binding/vendor_product_binding.dart';
import 'package:the_noire_hub_v1/features/vendor/vendorStoreScreen/data/vendor_products_response_model.dart';
import '../../features/authentication/gmailVerification/presentation/screen/gmail_verification_screen.dart';
import '../../features/authentication/login/presentation/bindings/login_binding.dart';
import '../../features/authentication/login/presentation/screen/login_screen.dart';
import '../../features/authentication/otpVerify/presentation/bindings/otp_verification_bindings.dart';
import '../../features/authentication/otpVerify/presentation/screen/otp_verify_screen.dart';
import '../../features/authentication/registration/presentation/screens/customer_address_add_screen.dart';
import '../../features/authentication/registration/presentation/screens/registration_screen.dart';
import '../../features/authentication/registration/presentation/screens/vendor_registration_screen.dart';
import '../../features/authentication/resetPassword/presentation/screen/reset_password_screen.dart';
import '../../features/beautician/beauticanStoreScreen/presentation/bindings/beautician_store_service_bindings.dart';
import '../../features/beautician/beauticanStoreScreen/presentation/screens/beautician_store_screen.dart';
import '../../features/beautician/beauticianAddService/presentation/bindings/beauticians_create_service_bindings.dart';
import '../../features/beautician/beauticianAvailabiltySection/presentation/screens/beautician_availability_section.dart';
import '../../features/beautician/beauticiansBookingHistory/presentation/bindings/beautician_booking_history_bindings.dart';
import '../../features/beautician/beauticiansBookingHistory/presentation/screens/beauticians_bookings_history_screen.dart';
import '../../features/beautician/editServiceScreen/presentation/bindings/beauticians_update_service_bindings.dart';
import '../../features/beautician/editServiceScreen/presentation/edit_service_screen.dart';
import '../../features/beautician/serviceDetailsScreen/presentation/service_details_screen.dart';
import '../../features/common/aboutUS/presentation/about_us_screen.dart';
import '../../features/common/addBank/presentation/add_bank_screen.dart';
import '../../features/common/addDealsPromos/presentation/bindings/deals_promos_bindings.dart';
import '../../features/common/addDealsPromos/presentation/screen/add_deals_pomos_screen.dart';
import '../../features/common/averageReviewScreen/presentation/screens/average_review_screens.dart';
import '../../features/common/bottomNavBar/customer/customer_main_container.dart';
import '../../features/common/bottomNavBar/vendor/vendor_main_container.dart';
import '../../features/common/businessDocument/presentation/bindings/business_info_bindings.dart';
import '../../features/common/businessDocument/presentation/screen/business_screen.dart';
import '../../features/common/changePassword/presentation/screen/change_password_screen.dart';
import '../../features/common/editProfile/presentation/binding/edit_profile_binding.dart';
import '../../features/common/editProfile/presentation/edit_profile_screen.dart';
import '../../features/common/feedback/presentation/bindings/feedback_bindings.dart';
import '../../features/common/feedback/presentation/screen/feedback_screen.dart';
import '../../features/common/help/presentation/help_screen.dart';
import '../../features/common/inviteFriends/presentation/invite_friends_screen.dart';
import '../../features/common/personalInfo/presentation/binding/personal_info_binding.dart';
import '../../features/common/personalInfo/presentation/personal_info_screen.dart';
import '../../features/common/profile/presentation/profile_screen.dart';
import '../../features/common/rating/presentation/rating_screen.dart';
import '../../features/common/selection/selection_screen.dart';
import '../../features/common/splash/splash_screen.dart';
import '../../features/common/termsOfService/presentation/screen/terms_of_service_screen.dart';
import '../../features/common/walletScreen/presentation/screen/wallet_screen.dart';
import '../../features/common/welcomeScreen/welcome_screen.dart';
import '../../features/customer/addPromo/presentation/add_promo_screen.dart';
import '../../features/customer/addTipScreen/presentation/add_tip_screen.dart';
import '../../features/customer/bookingSuccess/presentation/customer_booking_success.dart';
import '../../features/customer/cart/presentation/screen/cart_screen.dart';
import '../../features/customer/checkOut/presentation/screen/check_out_screen.dart';
import '../../features/customer/customerAppointmentScreen/presentation/screen/customer_appoinment_screen.dart';
import '../../features/customer/customerBookingList/presentation/bindings/customer_booking_list_bindings.dart';
import '../../features/customer/customerBookingList/presentation/screen/customer_bookings_list.dart';
import '../../features/customer/customerConfirmBookings/presentation/customer_confirm_bookings.dart';
import '../../features/customer/customerOrderScreen/presentation/screen/customer_orders_screen.dart';
import '../../features/customer/customerProducts/presentation/bindings/customer_products_bindings.dart';
import '../../features/customer/customerProducts/presentation/customer_products_screen.dart';
import '../../features/customer/customerServiceProductDetails/presentation/customer_service_product_details_screen.dart';
import '../../features/customer/customerServices/presentation/customer_service_screen.dart';
import '../../features/customer/dealsPromos/presentation/screens/customer_deals_promos_screen.dart';
import '../../features/customer/dealsPromosHistory/presentation/deals_promos_history_screen.dart';
import '../../features/customer/favourite/presentation/favourites_screen.dart';
import '../../features/customer/multiVendorCartScreen/presentation/bindings/multi_vendor_cart_bindings.dart';
import '../../features/customer/multiVendorCartScreen/presentation/screen/multi_vendor_cart_screen.dart';
import '../../features/customer/orderSuccessScreen/order_success_screen.dart';
import '../../features/customer/popularNearYou/presentation/service_popular_near_you_screen.dart';
import '../../features/customer/productDetailsScreen/presentation/product_details_screen.dart';
import '../../features/customer/productRating/presentation/bindings/product_rating_bindings.dart';
import '../../features/customer/productRating/presentation/product_rating_screen.dart';
import '../../features/customer/serviceBookingScreen/presentation/bindings/service_booking_details_bindings.dart';
import '../../features/customer/serviceBookingScreen/presentation/screen/service_booking_screen.dart';
import '../../features/customer/serviceRating/presentation/bindings/service_rating_bindings.dart';
import '../../features/customer/serviceRating/presentation/service_rating_screen.dart';
import '../../features/customer/vendorStoreList/presentation/screens/vendor_store_list_screen.dart';
import '../../features/vendor/editProductDetails/presentation/edit_product_details_screen.dart';
import '../../features/vendor/orderFullFillment/presentation/screen/order_full_fillment_screen.dart';
import '../../features/vendor/storeSetUp/presentation/screens/store_setup_screen.dart';
import '../../features/vendor/vendorAddProduct/presentation/bindings/vendor_add_product_bindings.dart';
import '../../features/vendor/vendorBillingSection/presentation/screens/vendor_billing_section.dart';
import '../../features/vendor/vendorEditProduct/presentation/bindings/vendor_edit_product_bindings.dart';
import '../../features/vendor/vendorEditProduct/presentation/screen/vendor_edit_product_screen.dart';
import '../../features/vendor/vendorOrderScreen/presentation/bindings/vendor_order_bindings.dart';
import '../../features/vendor/vendorOrderScreen/presentation/screens/vendor_order_screen.dart';
import '../../features/vendor/vendorProductDetailsScreen/presentation/bindings/vendor_product_details_bindings.dart';
import '../../features/vendor/vendorProductDetailsScreen/presentation/vendor_product_details_screen.dart';
import '../../features/vendor/vendorStoreScreen/presentation/screens/vendor_store_screen.dart';
import '../bindings/initialBindings.dart';

class AppPages {
  static const initial = RouteConstants.splash;

  static final routes = [
    GetPage(
      name: RouteConstants.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: RouteConstants.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.registration,
      page: () => const RegistrationScreen(),
      binding: RegistrationBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.vendorRegistration,
      page: () => const VendorRegistrationScreen(),
      binding: RegistrationBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.selection,
      page: () => const SelectionScreen(),
      binding: RegistrationBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.customerAddAddress,
      page: () => const CustomerAddressAddScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.customerServices,
      page: () => const CustomerServiceScreen(),
      binding: CustomerServiceBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.customerMainContainer,
      page: () => const CustomerMainContainer(),
      binding: InitialBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.vendorMainContainer,
      page: () => const VendorMainContainer(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.customerServiceProductDetailsScreen,
      page: () => const ServiceProviderDetailScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.customerServiceBookingScreen,
      page: () => const ServiceBookingScreen(),
      binding: ServiceBookingDetailsBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.customerConfirmBookings,
      page: () => const CustomerConfirmBookings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.customerBookingSuccess,
      page: () => const CustomerBookingSuccess(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.profileScreen,
      page: () => const ProfileScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.customerBookingsList,
      page: () => const CustomerBookingsList(),
      binding: CustomerBookingListBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.customerAppointmentScreen,
      page: () => const CustomerAppoinmentScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.myCartScreen,
      page: () => const CartScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.checkOutScreen,
      page: () => const CheckoutScreen(),
      bindings: [ CheckOutBindings(),OrderFullFillmentBindings(),CustomerDealsPromosBindings()],
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.orderSuccessScreen,
      page: () => const OrderSuccessScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.productDetailsScreen,
      page: () => const ProductDetailScreen(),
      binding: ProductDetailsBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.vendorStoreListScreen,
      page: () => const VendorStoreListScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.favouritesScreen,
      page: () => const FavoritesScreen(),
      binding: FavoritesBindings(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: RouteConstants.welcomeScreen,
      page: () => const WelcomeScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.storeSetUp,
      page: () => const StoreSetupScreen(),
      binding: RegistrationBinding(),
      transition: Transition.cupertino,
    ),
    // GetPage(
    //   name: RouteConstants.addProductsScreen,
    //   page: () => const AddProductsScreen(),
    //   transition: Transition.cupertino,
    // ),
    GetPage(
      name: RouteConstants.vendorBillingSection,
      page: () => const VendorBillingSection(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.businessScreen,
      page: () => const BusinessScreen(),
      bindings: [BusinessInfoBindings(), BusinessDocumentsBindings()],
      transition: Transition.cupertino,
    ),

    GetPage(
      name: RouteConstants.customerOrdersScreen,
      page: () => const CustomerOrdersScreen(),
      binding: CustomerOrdersBindings(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: RouteConstants.personalInfoScreen,
      page: () => const PersonalInfoScreen(),
      binding: PersonalInfoBinding(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: RouteConstants.termsOfServiceScreen,
      page: () => const TermsOfServiceScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.aboutUsScreen,
      page: () => const AboutUsScreen(),
      transition: Transition.cupertino,
    ),
    // GetPage(
    //   name: RouteConstants.serviceDealsPromos,
    //   page: () => const ServiceDealsPromosScreen(),
    //   transition: Transition.cupertino,
    // ),
    GetPage(
      name: RouteConstants.dealsPromos,
      page: () => const CustomerDealsPromosScreen(),
      binding: CustomerDealsPromosBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.dealsPromosHistory,
      page: () => const DealsPromosHistoryScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.helpScreen,
      page: () => const HelpScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.rateServiceScreen,
      page: () => const RatingScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.addTipScreen,
      page: () => const AddTipScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.addPromoScreen,
      page: () => const AddPromoScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.orderFullFillMent,
      page: () => const OrderFulfillmentScreen(),
      binding: OrderFullFillmentBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.gmailVerification,
      page: () => const GmailVerificationScreen(),
      binding: GmailVerificationBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.otpVerifyScreen,
      page: () => const OtpVerificationScreen(),
      binding: OtpVerificationBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.resetPasswordScreen,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: ChangePasswordBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.walletScreen,
      page: () => const WalletScreen(),
      binding: WalletInfoBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.beauticiansAvailabilityScreen,
      page: () => const VendorAvailabilitySection(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.reviewScreen,
      page: () => const ReviewsScreen(),
      binding: AverageReviewBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.beauticiansBookingHistoryScreen,
      page: () => const BeauticianBookingHistoryScreen(),
      binding: BeauticianBookingHistoryBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.vendorOrdersScreen,
      page: () => const VendorOrdersScreen(),
      binding: VendorOrderBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.inviteScreens,
      page: () => const InviteFriendsScreen(),
      binding: InviteFriendsBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.multiVendorCartScreen,
      page: () => const MultiVendorCartScreen(),
      binding: MultiVendorCartBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.servicePopularNearYou,
      page: () => const ServicePopularNearYouScreen(),
      binding: CustomerProductsBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.editProfile,
      page: () => const EditProfileScreen(),
      binding: EditProfileBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.vendorStoreScreen,
      page: () => const VendorStoreScreen(),
      binding: VendorProductBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.editProductDetailScreen,
      page: () => const EditProductDetailsScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.vendorProductDetailScreen,
      page: () => const VendorProductDetailsScreen(),
      binding: VendorProductDetailsBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.addDealsPromos,
      page: () => const AddDealsPomosScreen(),
      binding: DealsPromosBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.addBankScreen,
      page: () => const AddBankScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.editServiceScreen,
      page: () => const EditServicesScreen(),
      binding: BeauticiansUpdateServiceBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.serviceDetailsScreen,
      page: () => const ServiceDetailsScreen(),
      binding: ServiceDetailsBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.vendorAddProductScreen,
      page: () => const VendorAddProductScreen(),
      binding: VendorAddProductBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.beauticiansAddServiceScreen,
      page: () => const BeauticianAddServiceScreen(),
      binding: BeauticiansCreateServiceBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.vendorEditProductScreen,
      page: () => VendorEditProductScreen(product: Get.arguments as Product),
      binding: VendorEditProductBindings(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: RouteConstants.beauticiansStoreScreen,
      page: () => const BeauticianStoreScreen(),
      binding: BeauticianStoreServiceBindings(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: RouteConstants.customerProducts,
      page: () => const CustomerProductsScreen(),
      binding: CustomerProductsBindings(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: RouteConstants.feedbackScreen,
      page: () => const FeedbackScreen(),
      binding: FeedbackBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.serviceRatingScreen,
      page: () => const ServiceRatingScreen(),
      binding: ServiceRatingBindings(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.productRatingScreen,
      page: () => const ProductRatingScreen(),
      binding: ProductRatingBindings(),
      transition: Transition.cupertino,
    ),
  ];
}
