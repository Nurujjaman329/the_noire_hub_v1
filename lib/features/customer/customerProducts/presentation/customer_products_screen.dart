
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:the_noire_hub_v1/core/constants/api_constants.dart';
import 'package:the_noire_hub_v1/features/customer/customerProducts/data/customer_products_response_model.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../common/category/presentation/controller/category_controller.dart';
import '../../../common/subCategories/presentation/controller/sub_categories_controller.dart';
import 'controller/customer_products_controller.dart';

class CustomerProductsScreen extends StatelessWidget {
  const CustomerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Initialize all required controllers
    final controller = Get.find<CustomerProductsController>();
    final categoryController = Get.find<CategoryController>();
    final subCategoryController = Get.find<SubCategoryController>();

    // Initial data fetch if not already loaded
    if (categoryController.categories.isEmpty) {
      categoryController.loadCategories();
    }

    final image = CacheService.userImage;
    final fullImageUrl = image.isNotEmpty ? "${ApiConstants.baseImageUrl}$image" : '';

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
              _buildHeader(fullImageUrl),
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

              // Reactive Specialties (Categories)
              _buildSpecialtiesList(categoryController, subCategoryController),

              SizedBox(height: 20.h),
              // Filter chips (Currently static as per your request)
              _buildFilterChips(),

              SizedBox(height: 20.h),

              // Reactive SubCategories
              _buildSubCategoryList(subCategoryController),

              SizedBox(height: 30.h),

              // --- DYNAMIC PRODUCT SECTION ---
              Obx(() {
                if (controller.isLoading.value && controller.productList.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF1D3826)));
                }
                if (controller.productList.isEmpty) {
                  return const Center(child: CustomText(text: "No products found"));
                }

                List<Widget> productRows = [];
                for (int i = 0; i < controller.productList.length; i += 2) {
                  List<Widget> rowItems = [];
                  rowItems.add(_buildProductCard(controller.productList[i]));
                  if (i + 1 < controller.productList.length) {
                    rowItems.add(_buildProductCard(controller.productList[i + 1]));
                  }
                  productRows.add(_buildHorizontalList(rowItems));
                  productRows.add(SizedBox(height: 20.h));
                }
                return Column(children: productRows);
              }),

              _buildPopularNearYouSection(),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Methods ---

  Widget _buildProductCard(CustomerProduct product) {
    final imageUrl = product.images.isNotEmpty ? product.images.first : '';
    final fullImageUrl = "${ApiConstants.baseImageUrl}$imageUrl";

    // --- CALCULATE DISTANCE ---
    String distanceText = "Distance unknown";

    // CacheService.lat/lon are user coordinates
    // product.location.coordinates[1] is Latitude, [0] is Longitude (GeoJSON standard)
    if (CacheService.lat != 0.0 && product.location.coordinates.length >= 2) {
      double distanceInMeters = Geolocator.distanceBetween(
        CacheService.lat,
        CacheService.lon,
        product.location.coordinates[1], // Latitude
        product.location.coordinates[0], // Longitude
      );

      double distanceInKm = distanceInMeters / 1000;

      // Format to 1 decimal place (e.g., 2.5 km) or whole number if preferred
      distanceText = "${distanceInKm.toStringAsFixed(1)} km away";
    }

    return _popularCard(
      product.name,
      product.price.toString(),
      distanceText, // Use the dynamic text here
      product.rating.toString(),
      product.images.isNotEmpty
          ? fullImageUrl
          : "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=500",
      onTap: () {
        Get.toNamed(
          RouteConstants.productDetailsScreen,
          arguments: product,
        );
      },
    );
  }


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



  Widget _buildHeader(String imageUrl) {
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
            CustomText(text: CacheService.formattedLocation, fontSize: 12.sp, color: AppColors.textHint),
          ],
        ),

        GestureDetector(
          onTap: () => Get.toNamed(RouteConstants.profileScreen),
          child: Container(
            height: 44.r,
            width: 44.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1D3826).withValues(alpha: 0.1),
            ),
            child: ClipOval(
              child: imageUrl.isNotEmpty // Use the parameter here
                  ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: 25.sp,
                  color: const Color(0xFF1D3826),
                ),
              )
                  : Icon(Icons.person, size: 25.sp, color: const Color(0xFF1D3826)),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSearchField() {
    final controller = Get.find<CustomerProductsController>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      height: 50.h,
      decoration: BoxDecoration(
        color: const Color(0XFFF1F0B2),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.searchController, // Link the controller
              onChanged: controller.onSearchChanged,    // Trigger search logic
              style: TextStyle(fontSize: 14.sp, color: Colors.black),
              decoration: InputDecoration(
                hintText: "Search services, products and stylists",
                hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0XFF000000).withOpacity(0.5)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          // Dynamic suffix icon: Show 'X' to clear, otherwise show Search icon
          Obx(() => controller.searchQuery.value.isNotEmpty
              ? GestureDetector(
            onTap: controller.clearSearch,
            child: Icon(Icons.close, color: Colors.black, size: 20.sp),
          )
              : Icon(Icons.search, color: const Color(0XFF000000), size: 22.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialtiesList(CategoryController catCtrl, SubCategoryController subCtrl) {
    return Obx(() {
      if (catCtrl.isLoading.value) return const LinearProgressIndicator();

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: catCtrl.categories.map((category) {
            // Check if this category is currently selected in the subcategory controller
            bool isSelected = subCtrl.selectedCategoryId == category.id;

            return _specialtyCard(
              category.name,
              "${ApiConstants.baseImageUrl}${category.image}",
              isSelected,
                  () {
                // When tapped, fetch subcategories for this specific category
                subCtrl.fetchSubCategories(categoryId: category.id);
              },
            );
          }).toList(),
        ),
      );
    });
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

  Widget _buildSubCategoryList(SubCategoryController subCtrl) {
    return Obx(() {
      if (subCtrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (subCtrl.subCategories.isEmpty) {
        return const SizedBox.shrink(); // Hide if no subcategories found
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: subCtrl.subCategories.map((sub) {
            return Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Column(
                children: [
                  Container(
                    width: 85.w,
                    height: 85.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: CustomNetworkImage(
                          imageUrl: "${ApiConstants.baseImageUrl}${sub.image}",
                          height: 75.h,
                          width: 75.w,
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                      ),
                    ),
                  ),
                  CustomText(
                    text: sub.name,
                    fontSize: 13.sp,
                    top: 10.h,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });
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