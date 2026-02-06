
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';

class CustomerProductsScreen extends StatelessWidget {
  const CustomerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              _buildHeader(),
              SizedBox(height: 20.h),
              _buildSearchField(),
              SizedBox(height: 25.h),

              const CustomText(
                text: "Our Specialties",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0XFF000000),
              ),
              SizedBox(height: 15.h),
              _buildSpecialtiesList(),

              SizedBox(height: 20.h),
              _buildFilterChips(),

              SizedBox(height: 20.h),
              _buildSubCategoryList(),
              SizedBox(height: 30.h),

              _buildHorizontalList([
                _popularCard(
                  "Braids By Mia",
                  "500",
                  "7 km away",
                  "4.8",
                  "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=500",
                ),
                _popularCard(
                  "Hair Studio",
                  "300",
                  "3 km away",
                  "4.5",
                  "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=500",
                ),
              ]),

              SizedBox(height: 20.h),

              _buildHorizontalList([
                _popularCard(
                  "Full Glam Makeup",
                  "100",
                  "5 km away",
                  "4.9 ( 125 )",
                  "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=500",
                ),
                _popularCard(
                  "Gel Manicure",
                  "100",
                  "5 km away",
                  "4.9 ( 125 )",
                  "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=500",
                ),
              ]),

              SizedBox(height: 20.h),

              _buildHorizontalList([
                _popularCard(
                  "Sarah Jenkins",
                  "100",
                  "5 km away",
                  "4.9 ( 125 )",
                  "https://images.unsplash.com/photo-1595152772835-219674b2a8a6?q=80&w=500",
                ),
                _popularCard(
                  "Elena Rodriguez",
                  "100",
                  "5 km away",
                  "4.9 ( 125 )",
                  "https://images.unsplash.com/photo-1580618672591-eb180b1a973f?q=80&w=500",
                ),
              ]),

              _buildPopularNearYouSection(),

              SizedBox(height: 20.h),

              _buildHorizontalList([
                _popularCard(
                  "First Booking: 20% OFF",
                  "100",
                  "5 km away",
                  "4.9 ( 125 )",
                  "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=500",
                ),
                _popularCard(
                  "Weekend Special",
                  "100",
                  "5 km away",
                  "4.9 ( 125 )",
                  "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?q=80&w=500",
                ),
              ]),

              SizedBox(height: 20.h),

              _buildHorizontalList([
                _popularCard(
                  "Box Braids",
                  "100",
                  "5 km away",
                  "4.9 ( 125 )",
                  "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=500",
                ),
                _popularCard(
                  "Lace Wig Install",
                  "100",
                  "5 km away",
                  "4.9 ( 125 )",
                  "https://images.unsplash.com/photo-1582095133179-bfd08e2fc6b3?q=80&w=500",
                ),
              ]),

              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Methods ---


  Widget _buildPopularNearYouSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteConstants.servicePopularNearYou);
            },
            child: _buildGridActionCard(
              title: "Popular Near You",
              description:
              "Trending hair styles provided by Beauticians located less than 5 km away from you",
              images: [
                "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=200",
                "https://images.unsplash.com/photo-1595152772835-219674b2a8a6?q=80&w=200",
                "https://images.unsplash.com/photo-1580618672591-eb180b1a973f?q=80&w=200",
                "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?q=80&w=200",
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteConstants.serviceDealsPromos);
            },
            child: _buildGridActionCard(
              title: "Deals & Promos",
              description:
              "Check out the most requested specialists in your current area this week",
              images: [
                "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80&w=200",
                "https://images.unsplash.com/photo-1582095133179-bfd08e2fc6b3?q=80&w=200",
                "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?q=80&w=200",
                "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=200",
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridActionCard({
    required String title,
    required String description,
    required List<String> images,
  }) {
    return Container(
      width: 310.w,
      margin: EdgeInsets.only(right: 20.w, bottom: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2x2 Grid
          SizedBox(
            height: 240.h,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: CustomNetworkImage(
                    imageUrl: images[index],
                    height: double.infinity,
                    width: double.infinity,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          // Footer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    SizedBox(height: 5.h),
                    CustomText(
                      text: description,
                      fontSize: 11.sp,
                      color: Colors.black54,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              // The Dark Green Arrow Button
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF1D3826),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: const Color(0xFFF1F0B2),
                  size: 16.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<Widget> cards) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: cards),
    );
  }



  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                AppColors.onPrimary,
                BlendMode.srcIn,
              ),
              child: Image.asset(
                AppAssets.appLogo,
                width: 50.w,
                fit: BoxFit.contain,
              ),
            ),

            CustomText(
              text: "Beauty",
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        Row(
          children: [
            CustomText(text: "72 Poplar Ave NW", fontSize: 12.sp, color: AppColors.textHint),
            Icon(Icons.keyboard_arrow_down, size: 18.sp, color: AppColors.textHint),
          ],
        ),

        GestureDetector(
          onTap: (){
            Get.toNamed(RouteConstants.profileScreen);
          },
          child: CircleAvatar(
            child: CustomNetworkImage(
              imageUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200",
              height: 100.h,
              width: 100.w,
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 50.h,
      decoration: BoxDecoration(
        color: Color(0XFFF1F0B2),
        // color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search services, products and stylists",
                hintStyle: TextStyle(fontSize: 12.sp, color: Color(0XFF000000)),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.search, color: Color(0XFF000000), size: 22.sp),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesList() {
    int selectedIndex = 0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _specialtyCard(
            "Hair Care",
            "https://cdn-icons-png.flaticon.com/512/1940/1940922.png",
            selectedIndex == 0,
                () => /* Update State */ {},
          ),
          _specialtyCard(
            "Make Up",
            "https://cdn-icons-png.flaticon.com/512/1940/1940922.png",
            selectedIndex == 1,
                () => {},
          ),
          _specialtyCard(
            "Nail Care",
            "https://cdn-icons-png.flaticon.com/512/1940/1940922.png",
            selectedIndex == 2,
                () => {},
          ),
          _specialtyCard(
            "Skin Care",
            "https://cdn-icons-png.flaticon.com/512/1940/1940922.png",
            selectedIndex == 3,
                () => {},
          ),
        ],
      ),
    );
  }

  // 2. Updated Card Method
  Widget _specialtyCard(
      String title,
      String imageUrl,
      bool isSelected,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 90.w, // Adjusted to match the squircle look
            height: 90.w,
            margin: EdgeInsets.only(right: 15.w, left: 5.w, bottom: 8.h),
            decoration: BoxDecoration(
              // Logic for color change
              color: isSelected
                  ? const Color(0xFF1D3826)
                  : const Color(0xFFF1F0B2),
              borderRadius: BorderRadius.circular(
                20.r,
              ), // High radius for that soft square look
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.15),
                  blurRadius: 10,
                  offset: const Offset(
                    0,
                    8,
                  ), // Shadow positioning like the image
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                height: 65.h,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  // If using a dark background, you might want to tint the icon/image
                  // if it's a simple icon, otherwise keep as is.
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          // Title outside the card as per the image
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: CustomText(
              text: title,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors
                  .black, // Text remains black regardless of card selection
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      // Removing horizontal padding from the Row since it's handled by the parent
      child: Row(
        children: [
          _filterChip("Rating", Icons.star_border),
          SizedBox(width: 10.w),
          _filterChip("Price", Icons.attach_money),
          SizedBox(width: 10.w),
          _filterChip("Distance", Icons.location_on_outlined),
          SizedBox(width: 10.w),
          _filterChip("Offers", Icons.local_offer_outlined),
          SizedBox(width: 10.w),
          _filterChip("Home Service", Icons.home_repair_service_outlined),
          SizedBox(width: 10.w),
          _filterChip("Favourites", Icons.favorite_outline_rounded),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }

  Widget _filterChip(String label, IconData icon, {bool isActive = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        // Change color based on selection state
        color: Color(0XFFB5B475),
        // color: isActive ? AppColors.navigationIndicator : AppColors.chipInactive,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isActive ? AppColors.primary : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: Color(0XFF000000),
            // color: isActive ? AppColors.white : AppColors.iconOnSurface
          ),
          SizedBox(width: 4.w),
          CustomText(
            text: label,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Color(0XFF000000),
            // color: isActive ? AppColors.white : AppColors.textPrimary,
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: 16.sp,
            color: Color(0XFF000000),
            // color: isActive ? AppColors.white : AppColors.iconOnSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryList() {
    // You can manage this with a state variable just like the specialties
    int selectedSubIndex = 0;

    final categories = [
      {"name": "Braids", "img": AppAssets.subCategory},
      {"name": "Faux Locs", "img": AppAssets.subCategory},
      {"name": "Kids", "img": AppAssets.subCategory},
      {"name": "Wig Install", "img": AppAssets.subCategory},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(categories.length, (index) {
          final isSelected = selectedSubIndex == index;
          final cat = categories[index];

          return Padding(
            padding: EdgeInsets.only(right: 15.w, left: index == 0 ? 5.w : 0),
            child: Column(
              children: [
                // The Rounded Container
                Container(
                  width: 85.w,
                  height: 85.w,
                  decoration: BoxDecoration(
                    // Use the pale yellow for selected, white for unselected
                    color: isSelected ? const Color(0xFFF1F0B2) : Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: Padding(
                      padding: EdgeInsets.all(
                        8.r,
                      ), // Padding for the image inside the card
                      child: CustomNetworkImage(
                        imageUrl: cat["img"]!,
                        height:
                        75.h, // Slightly smaller than container for padding
                        width: 75.w,
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                    ),
                  ),
                ),
                // The Label
                CustomText(
                  text: cat["name"]!,
                  fontSize: 13.sp,
                  top: 10.h,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _popularCard(
      String name,
      String price,
      String distance,
      String rating,
      String imageUrl, {
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap ?? () {
        Get.toNamed(
          RouteConstants.productDetailsScreen, // Ensure this matches your route name
          arguments: {
            'title': name,
            'price': price,
            'image': imageUrl,
          },
        );
      },
      child: Container(
        width: 220.w,
        margin: EdgeInsets.only(right: 20.w, bottom: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F0B2),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Prevents vertical overflow
          children: [
            // 1. Image Section
            Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: imageUrl,
                  height: 180.h,
                  width: double.infinity,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: CircleAvatar(
                    radius: 18.r,
                    backgroundColor: const Color(0xFF1D3826).withValues(alpha:0.8),
                    child: Icon(
                      Icons.favorite,
                      color: const Color(0xFFF1F0B2),
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),

            // 2. Info Section (Fixed for Overflow)
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Expanded ensures the name doesn't push the category off screen
                      Expanded(
                        flex: 2,
                        child: CustomText(
                          text: name,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp, // Reduced size for better fit
                          color: const Color(0xFF000000),
                          maxLines: 1, // Prevents text from wrapping to new line
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        flex: 1,
                        child: CustomText(
                          text: "Knotless",
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                          color: const Color(0xFF000000),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Wrap the left column in Expanded to give space to the Price
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: distance,
                              fontSize: 11.sp,
                              color: const Color(0xFF000000),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            CustomText(
                              text: "$rating ★",
                              fontSize: 11.sp,
                              color: const Color(0xFF9BB575),
                            ),
                          ],
                        ),
                      ),
                      // Price remains fixed size but shouldn't overflow
                      CustomText(
                        text: "\$$price",
                        fontSize: 20.sp, // Slightly smaller to prevent overlap
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF000000),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}