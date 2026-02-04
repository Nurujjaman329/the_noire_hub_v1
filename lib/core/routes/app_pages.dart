
import 'package:get/get.dart';
import 'package:the_noire_hub_v1/core/constants/route_constants.dart';
import 'package:the_noire_hub_v1/features/authentication/gmailVerification/presentation/bindings/gmail_verification_bindings.dart';
import 'package:the_noire_hub_v1/features/authentication/registration/presentation/bindings/registration_bindings.dart';
import 'package:the_noire_hub_v1/features/authentication/resetPassword/presentation/bindings/reset_password_bindings.dart';
import '../../features/authentication/gmailVerification/presentation/screen/gmail_verification_screen.dart';
import '../../features/authentication/login/presentation/bindings/login_binding.dart';
import '../../features/authentication/login/presentation/screen/login_screen.dart';
import '../../features/authentication/otpVerify/presentation/bindings/otp_verification_bindings.dart';
import '../../features/authentication/otpVerify/presentation/screen/otp_verify_screen.dart';
import '../../features/authentication/registration/presentation/screens/customer_address_add_screen.dart';
import '../../features/authentication/registration/presentation/screens/registration_screen.dart';
import '../../features/authentication/registration/presentation/screens/vendor_registration_screen.dart';
import '../../features/authentication/resetPassword/presentation/screen/reset_password_screen.dart';
import '../../features/beautician/beauticianAvailabiltySection/presentation/screens/beautician_availability_section.dart';
import '../../features/beautician/beauticiansBookingHistory/presentation/screens/beauticians_bookings_history_screen.dart';
import '../../features/beautician/editServiceScreen/presentation/edit_service_screen.dart';
import '../../features/beautician/serviceDetailsScreen/presentation/service_details_screen.dart';
import '../../features/common/aboutUS/presentation/about_us_screen.dart';
import '../../features/common/addBank/presentation/add_bank_screen.dart';
import '../../features/common/addDealsPromos/presentation/screen/add_deals_pomos_screen.dart';
import '../../features/common/averageReviewScreen/presentation/screens/average_review_screens.dart';
import '../../features/common/bottomNavBar/customer/customer_main_container.dart';
import '../../features/common/bottomNavBar/vendor/vendor_main_container.dart';
import '../../features/common/changePassword/presentation/screen/change_password_screen.dart';
import '../../features/common/editProfile/presentation/edit_profile_screen.dart';
import '../../features/common/help/presentation/help_screen.dart';
import '../../features/common/inviteFriends/presentation/invite_friends_screen.dart';
import '../../features/common/personalInfo/presentation/personal_info_screen.dart';
import '../../features/common/profile/presentation/profile_screen.dart';
import '../../features/common/rating/presentation/rating_screen.dart';
import '../../features/common/selection/selection_screen.dart';
import '../../features/common/splash/splash_screen.dart';
import '../../features/common/termsOfService/presentation/screen/terms_of_service_screen.dart';
import '../../features/common/vendorAddProducts/presentation/screens/add_products_screen.dart';
import '../../features/common/walletScreen/presentation/screen/wallet_screen.dart';
import '../../features/common/welcomeScreen/welcome_screen.dart';
import '../../features/customer/addPromo/presentation/add_promo_screen.dart';
import '../../features/customer/addTipScreen/presentation/add_tip_screen.dart';
import '../../features/customer/bookingSuccess/presentation/customer_booking_success.dart';
import '../../features/customer/cart/presentation/screen/cart_screen.dart';
import '../../features/customer/checkOut/presentation/screen/check_out_screen.dart';
import '../../features/customer/customerAppointmentScreen/presentation/screen/customer_appoinment_screen.dart';
import '../../features/customer/customerBookingList/presentation/screen/customer_bookings_list.dart';
import '../../features/customer/customerConfirmBookings/presentation/customer_confirm_bookings.dart';
import '../../features/customer/customerOrderScreen/presentation/screen/customer_orders_screen.dart';
import '../../features/customer/customerServiceProductDetails/presentation/customer_service_product_details_screen.dart';
import '../../features/customer/customerServices/presentation/customer_service_screen.dart';
import '../../features/customer/dealsPromos/presentation/service_deals_promos_screen.dart';
import '../../features/customer/dealsPromos/presentation/screens/deals_promos_screen.dart';
import '../../features/customer/dealsPromosHistory/presentation/deals_promos_history_screen.dart';
import '../../features/customer/favourite/presentation/favourites_screen.dart';
import '../../features/customer/multiVendorCartScreen/presentation/screen/multi_vendor_cart_screen.dart';
import '../../features/customer/orderSuccessScreen/order_success_screen.dart';
import '../../features/customer/popularNearYou/presentation/service_popular_near_you_screen.dart';
import '../../features/customer/productDetailsScreen/presentation/product_details_screen.dart';
import '../../features/customer/serviceBookingScreen/presentation/screen/service_booking_screen.dart';
import '../../features/customer/vendorStoreList/presentation/screens/vendor_store_list_screen.dart';
import '../../features/vendor/businessScreen/presentation/screen/business_screen.dart';
import '../../features/vendor/editProductDetails/presentation/edit_product_details_screen.dart';
import '../../features/vendor/orderFullFillment/presentation/screen/order_full_fillment_screen.dart';
import '../../features/vendor/storeSetUp/presentation/screens/store_setup_screen.dart';
import '../../features/vendor/vendorBillingSection/presentation/screens/vendor_billing_section.dart';
import '../../features/vendor/vendorOrderScreen/presentation/screens/vendor_order_screen.dart';
import '../../features/vendor/vendorProductDetailsScreen/presentation/vendor_product_details_screen.dart';
import '../../features/vendor/vendorStoreScreen/presentation/screens/vendor_store_screen.dart';

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
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.customerMainContainer,
      page: () => const CustomerMainContainer(),
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
    GetPage(
      name: RouteConstants.addProductsScreen,
      page: () => const AddProductsScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.vendorBillingSection,
      page: () => const VendorBillingSection(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.businessScreen,
      page: () => const BusinessScreen(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: RouteConstants.customerOrdersScreen,
      page: () => const CustomerOrdersScreen(),
      transition: Transition.cupertino,
    ),

    GetPage(
      name: RouteConstants.personalInfoScreen,
      page: () => const PersonalInfoScreen(),
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
    GetPage(
      name: RouteConstants.serviceDealsPromos,
      page: () => const ServiceDealsPromosScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.dealsPromos,
      page: () => const DealsPromosScreen(),
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
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.walletScreen,
      page: () => const WalletScreen(),
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
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.beauticiansBookingHistoryScreen,
      page: () => const BeauticianBookingHistoryScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.vendorOrdersScreen,
      page: () => const VendorOrdersScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.inviteScreens,
      page: () => const InviteFriendsScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.multiVendorCartScreen,
      page: () => const MultiVendorCartScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.servicePopularNearYou,
      page: () => const ServicePopularNearYouScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.editProfile,
      page: () => const EditProfileScreen(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.vendorStoreScreen,
      page: () => const VendorStoreScreen(),
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
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.addDealsPromos,
      page: () => const AddDealsPomosScreen(),
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
      transition: Transition.cupertino,
    ),
    GetPage(
      name: RouteConstants.serviceDetailsScreen,
      page: () => const ServiceDetailsScreen(),
      transition: Transition.cupertino,
    ),
  ];
}