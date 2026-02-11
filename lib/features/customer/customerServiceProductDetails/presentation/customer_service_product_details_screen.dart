
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/custom_text.dart';

class ServiceProviderDetailScreen extends StatelessWidget {
  const ServiceProviderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the data passed from the previous screen
    final dynamic data = Get.arguments;
    final String title = data['title'] ?? "Service Provider";
    final String imageUrl = data['imageUrl'] ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image with Back Button
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 300.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                      height: 300.h,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image)
                  ),
                ),
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  child: GestureDetector(
                    onTap: () => Get.back(), // GetX back navigation
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha:0.5),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                    ),
                  ),
                ),
                // Floating White Info Card
                Container(
                  margin: EdgeInsets.only(top: 240.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.r),
                      topRight: Radius.circular(40.r),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                  child: Column(
                    children: [
                      CustomText(
                        text: title,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5.h),
                      CustomText(
                        text: "4.4 ☆ (25) | \$2/km home service fee | 7 km away",
                        fontSize: 12.sp,
                        color: Color(0XFF000000),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(thickness: 3, color: Color(0xFFC4C99A)),

            // Services Section: Braids
            _buildServiceCategory("Braids", [
              _serviceItemCard("Havana Twists", "\$90", "https://images.unsplash.com/photo-1582095133179-bfd08e2fc6b3?q=80&w=200"),
              _serviceItemCard("Senegalese Twists", "\$90", "https://images.unsplash.com/photo-1560869713-7d0a29430803?q=80&w=200"),
              _serviceItemCard("Marley Twists", "\$95", "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?q=80&w=200"),
            ]),

            // Services Section: Twists
            _buildServiceCategory("Twists", [
              _serviceItemCard("Havana Twists", "\$90", "https://images.unsplash.com/photo-1582095133179-bfd08e2fc6b3?q=80&w=200"),
              _serviceItemCard("Senegalese Twists", "\$90", "https://images.unsplash.com/photo-1560869713-7d0a29430803?q=80&w=200"),
              _serviceItemCard("Marley Twists", "\$95", "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?q=80&w=200"),
            ]),

            _buildServiceCategory("Cornrows", [
              _serviceItemCard("Havana Twists", "\$90", "https://images.unsplash.com/photo-1582095133179-bfd08e2fc6b3?q=80&w=200"),
              _serviceItemCard("Senegalese Twists", "\$90", "https://images.unsplash.com/photo-1560869713-7d0a29430803?q=80&w=200"),
              _serviceItemCard("Marley Twists", "\$95", "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?q=80&w=200"),
            ]),

            // Services Section: Twists
            _buildServiceCategory("Dread Locs", [
              _serviceItemCard("Havana Twists", "\$90", "https://images.unsplash.com/photo-1582095133179-bfd08e2fc6b3?q=80&w=200"),
              _serviceItemCard("Senegalese Twists", "\$90", "https://images.unsplash.com/photo-1560869713-7d0a29430803?q=80&w=200"),
              _serviceItemCard("Marley Twists", "\$95", "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?q=80&w=200"),
            ]),

            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  // --- Helper Methods ---

  Widget _buildServiceCategory(String categoryTitle, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 15.h),
          child: CustomText(text: categoryTitle, fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: Colors.grey),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 20.w),
            child: Row(children: items),
          ),
      ],
    );
  }

  Widget _serviceItemCard(String name, String price, String img) {
    return GestureDetector(
      onTap: () {
        // Navigate to Booking Screen using GetX
        Get.toNamed(
          RouteConstants.customerServiceBookingScreen,
          arguments: {
            'name': name,
            'img': img,
            'price': price,
          },
        );
      },
      child: Container(
        width: 115.w,
        margin: EdgeInsets.only(right: 15.w),
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F0B2),
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha:0.05),
                blurRadius: 5,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.network(img, height: 90.h, width: 100.w, fit: BoxFit.cover),
            ),
            SizedBox(height: 8.h),
            CustomText(
                text: name,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
               color: Color(0XFF000000),
            ),
            CustomText(
                text: price,
                fontSize: 10.sp,
              color: Color(0XFF000000),
                textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}