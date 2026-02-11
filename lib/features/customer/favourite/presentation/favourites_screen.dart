import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: CustomText(
            text: "Favorites",
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFF435B33),
            indicatorWeight: 3,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: "Vendors"),
              Tab(text: "Beauticians"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Vendors
            _buildFavoritesList(isVendor: true),
            // Tab 2: Beauticians (Reusing the same UI structure)
            _buildFavoritesList(isVendor: false),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList({required bool isVendor}) {
    // Shared data list: In a real app, these would be separate lists
    final List<Map<String, String>> data = isVendor
        ? [
      {"name": "Ada's Body Shop", "orders": "10", "country": "Canada"},
      {"name": "Ivana Care Studio", "orders": "5", "country": "Ghana"},
      {"name": "Skie Homemade Products", "orders": "7", "country": "USA"},
    ]
        : [
      {"name": "Sarah's Glow Spa", "orders": "3", "country": "UK"},
      {"name": "Beauty by Amina", "orders": "12", "country": "Nigeria"},
    ];

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      itemCount: data.length,
      separatorBuilder: (context, index) => Divider(height: 30.h, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        return _buildStoreItem(
          name: data[index]['name']!,
          orders: data[index]['orders']!,
          location: data[index]['country']!,
          // Example image placeholder
          imageUrl: "https://picsum.photos/id/${index + (isVendor ? 10 : 50)}/200",
        );
      },
    );
  }

  Widget _buildStoreItem({
    required String name,
    required String orders,
    required String location,
    required String imageUrl,
  }) {
    return Row(
      children: [
        // 1. Circular Image
        Container(
          height: 60.r,
          width: 60.r,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: CustomNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover, height: 30, width: 30,
            ),
          ),
        ),
        SizedBox(width: 15.w),
        // 2. Info Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: name, fontSize: 15.sp, fontWeight: FontWeight.bold),
              CustomText(text: "$orders previous orders", fontSize: 11.sp, color: Colors.black54),
              CustomText(text: location, fontSize: 11.sp, color: Colors.black54),
            ],
          ),
        ),
        // 3. Action Button
        GestureDetector(
          onTap: () => Get.toNamed('/storeScreen'),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: const Color(0xFF8B9467), // Same olive green
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: CustomText(
              text: "View Store",
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}