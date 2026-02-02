import 'package:get/get.dart';

class BookingTabController extends GetxController {
  var selectedTab = "Complete".obs;

  void changeTab(String value) {
    selectedTab.value = value;
  }
}