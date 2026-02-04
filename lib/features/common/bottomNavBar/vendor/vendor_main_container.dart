import 'package:flutter/material.dart';
import 'package:the_noire_hub_v1/features/common/bottomNavBar/vendor/vendor_bottom_navBar.dart';
import 'package:the_noire_hub_v1/features/common/bottomNavBar/vendor/vendor_main_controller.dart';
import 'package:get/get.dart';



class VendorMainContainer extends StatelessWidget {
  const VendorMainContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorMainController());

    return Obx(() {
      // Show a loader if role isn't determined yet
      if (controller.userRole.value.isEmpty) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: controller.getPages(),
        ),
        bottomNavigationBar: VendorBottomNavbar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          isVendor: controller.isVendor,
        ),
      );
    });
  }
}