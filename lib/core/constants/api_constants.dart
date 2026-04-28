class ApiConstants {
  //common

  // static const String baseUrl = 'http://10.10.11.88:3000/api/v1/';
  static const String baseUrl = 'https://ton3000.fuez.co.za/api/v1/';
  static const String imageUrl = 'https://ton3000.fuez.co.za';
  static const String baseImageUrl = imageUrl;

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const String registration = "auth/register";
  static const String login = "auth/login";
  static const String categories = "categories";
  static const String subCategories = "subcategories";
  static const String verifyOtp = "auth/verify-email";
  static const String resendOtp = "auth/resend-otp";
  static const String verifyMail = "auth/forgot-password";
  static const String resetPassword = "auth/reset-password";
  static const String changePassword = "auth/change-password";
  static const String deleteMe = "auth/delete-me";
  static const String getProfile = "users/self/in";
  static const String updateProfile = "users/self/update";
  static const String addBusinessDocuments = "business-documents";
  static const String getBusinessDocuments = "business-documents/my-document";
  static const String getBusinessInfo = "business/me";
  static const String categoryUpdate = "users/self/selected-categories";
  static const String promoCode = "promo-codes";
  static const String promoCodeCustomer = "promo-codes/all";
  static const String feedback = "feedback";
  static const String inviteLink = "invite/link";
  static const String cart = "cart";
  static const String wallet = "wallet";
  static const String walletWithDraw = "wallet/withdraw";
  static const String withdrawHistory = "wallet/withdrawals";
  static const String evaluationsBase = "evaluation/";
  static const String termsOfService = "admin/content/terms-of-service";
  static const String aboutUs = "admin/content/about";
  static const String helpContent = "admin/content/help";
  static const String totalEarning = "wallet/earnings";



  //customer
  static const String customerProducts = "products";
  static const String customerServices = "services";
  static const String customerBookings = "bookings";
  static const String customerFavorites = "favorites";
  static const String cartItems = "cart/items";
  static const String productOrders = "product-orders";
  static const String serviceRating = "reviews/booking/";
  static const String productRating = "product-reviews/";
  static const String conversations = "conversations";
  static const String singleConversations = "conversations/";



  //beauticians

  static const String beauticianServiceList = "services/my-services";
  static const String serviceRoute = "services";


  //vendor

  static const String vendorProductList = "products/my-products";
  static const String vendorSingleProduct = "products/";
  static const String vendorDeleteSingleProduct = "products/";
  static const String vendorCreateProduct = "products/";
  static const String vendorEditProduct = "products/";
  static const String orderFullFillMent = "order-fulfillment";

}
