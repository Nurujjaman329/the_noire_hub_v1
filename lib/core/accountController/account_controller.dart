// import 'package:get/get.dart';
//
// class AccountController extends GetxController {
//   var userType = "customer".obs; // Can be "customer", "vendor", or "beautician"
//
//   // Track if the user has already dealt with the dialog
//   var hasDismissedActionDialog = false.obs;
//
//   bool get isVendor => userType.value == "vendor" || userType.value == "vendors";
//   bool get isBeautician => userType.value == "beautician" || userType.value == "beauticians";
//   bool get isCustomer => userType.value == "customer";
//
//   void setUserType(String type) => userType.value = type;
//
//   // Call this when they verify or close the dialog
//   void dismissDialog() => hasDismissedActionDialog.value = true;
// }