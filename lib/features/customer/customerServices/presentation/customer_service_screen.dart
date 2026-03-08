import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/services/cache_service.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';
import '../../../common/category/presentation/controller/category_controller.dart';
import '../../../common/subCategories/presentation/controller/sub_categories_controller.dart';
import '../data/customer_services_response_model.dart';
import 'controller/customer_service_controller.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerServiceController>();
    final categoryController = Get.find<CategoryController>();
    final subCategoryController = Get.find<SubCategoryController>();

    if (categoryController.categories.isEmpty) {
      categoryController.loadCategories();
    }

    final image = CacheService.userImage;
    final fullImageUrl = image.isNotEmpty ? "${ApiConstants.baseImageUrl}$image" : '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // NotificationListener detects scroll without needing a ScrollController
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
              controller.loadMore();
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () => controller.fetchService(),
            color: const Color(0xFF1D3826),
            child: SingleChildScrollView(
              // Changed to AlwaysScrollable so RefreshIndicator always works
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
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

                  _buildSpecialtiesList(categoryController, subCategoryController, controller),

                  SizedBox(height: 20.h),
                  _buildFilterChips(),
                  SizedBox(height: 20.h),

                  _buildSubCategoryList(subCategoryController, controller),

                  SizedBox(height: 30.h),

                  // --- DYNAMIC Service SECTION ---
                  Obx(() {
                    if (controller.isLoading.value && controller.serviceList.isEmpty) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Column(
                          children: List.generate(3, (index) => Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Row(
                              children: [
                                _skeletonServiceCard(),
                                SizedBox(width: 15.w),
                                _skeletonServiceCard(),
                              ],
                            ),
                          )),
                        ),
                      );
                    }

                    if (controller.serviceList.isEmpty) {
                      return _buildEmptyState(controller); // Extracted for cleanliness
                    }

                    List<Widget> serviceRows = [];
                    for (int i = 0; i < controller.serviceList.length; i += 2) {
                      List<Widget> rowItems = [];
                      rowItems.add(_buildServiceCard(controller.serviceList[i]));
                      if (i + 1 < controller.serviceList.length) {
                        rowItems.add(_buildServiceCard(controller.serviceList[i + 1]));
                      }
                      serviceRows.add(_buildHorizontalList(rowItems));
                      serviceRows.add(SizedBox(height: 20.h));
                    }

                    // Add a small loader at the bottom when fetching more pages
                    return Column(
                      children: [
                        ...serviceRows,
                        if (controller.isMoreLoading.value)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: const CircularProgressIndicator(color: Color(0xFF1D3826)),
                          ),
                      ],
                    );
                  }),

                  _buildPopularNearYouSection(),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _skeletonServiceCard() {
    return Expanded(
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  // Helper for Empty state to keep the build method clean
  Widget _buildEmptyState(CustomerServiceController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomNetworkImage(
              imageUrl: AppAssets.empty,
              height: 200.h,
              width: 200.w,
              fit: BoxFit.contain,
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 20.h),
            const CustomText(
              text: "No stylists found",
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
            SizedBox(height: 10.h),
            const CustomText(
              text: "Try adjusting your distance or price range",
              fontSize: 12,
              color: Colors.grey,
            ),
            SizedBox(height: 20.h),
            TextButton(
              onPressed: () {
                controller.clearSearch();
                controller.clearPrice();
                controller.clearRating();
                controller.resetDistance();
                controller.priceRange.value = const RangeValues(1, 50000);
              },
              child: const CustomText(
                text: "Clear All Filters",
                color: Color(0xFF1D3826),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // --- Helper Methods ---

  Widget _buildServiceCard(CustomerService service) {
    final controller = Get.find<CustomerServiceController>();
    final imageUrl = service.images.isNotEmpty ? service.images.first : '';
    final fullImageUrl = "${ApiConstants.baseImageUrl}$imageUrl";

    // --- CALCULATE DISTANCE ---
    String distanceText = "Distance unknown";

    if (CacheService.lat != 0.0 && service.location.coordinates.length >= 2) {
      double distanceInMeters = Geolocator.distanceBetween(
        CacheService.lat,
        CacheService.lon,
        service.location.coordinates[1], // Latitude
        service.location.coordinates[0], // Longitude
      );

      double distanceInKm = distanceInMeters / 1000;
      distanceText = "${distanceInKm.toStringAsFixed(1)} km away";
    }

    return Obx(() {
      // 1. Check if this specific service is currently processing a favorite toggle
      final isProcessing = controller.favoriteLoadingState[service.id] ?? false;

      return _popularCard(
        service.name,
        service.price.toString(),
        distanceText,
        service.rating.toString(),
        service.images.isNotEmpty
            ? fullImageUrl
            : "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=500",
        isFavorite: service.isFavorite,
        isFavoriteLoading: isProcessing, // 2. Pass the loading state
        onTap: () {
          Get.toNamed(
            RouteConstants.customerServiceBookingScreen,
            arguments: service,
          );
        },
        onFavoriteTap: () {
          // 3. HIT THE POST HERE for Service
          controller.toggleServiceFavorite(service.id);
        },
      );
    });
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
            const CustomText(
              text: "Beauty",
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        CustomText(
            text: CacheService.formattedLocation,
            fontSize: 12.sp,
            color: AppColors.textHint
        ),
        GestureDetector(
          onTap: () => Get.toNamed(RouteConstants.profileScreen),
          child: CustomNetworkImage(
            imageUrl: imageUrl,
            height: 44.r,
            width: 44.r,
            boxShape: BoxShape.circle,
            // If the image is empty, your internal _buildErrorWidget
            // already handles the Icons.person fallback.
          ),
        )
      ],
    );
  }

  Widget _buildSearchField() {
    final controller = Get.find<CustomerServiceController>();

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
                hintText: "Search services, services and stylists",
                hintStyle: TextStyle(fontSize: 12.sp, color: const Color(0XFF000000).withValues(alpha:0.5)),
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

  Widget _buildSpecialtiesList(
      CategoryController catCtrl,
      SubCategoryController subCtrl,
      CustomerServiceController serviceCtrl) {
    return Obx(() {
      if (catCtrl.isLoading.value) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (index) => _buildSkeletonCard()),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: catCtrl.categories.map((category) {
            bool isSelected = serviceCtrl.selectedCategoryId.value == category.id;
            return _specialtyCard(
              category.name,
              "${ApiConstants.baseImageUrl}${category.image}",
              isSelected,
                  () {
                subCtrl.fetchSubCategories(categoryId: category.id);
                serviceCtrl.filterByCategory(category.id);
              },
            );
          }).toList(),
        ),
      );
    });
  }

  Widget _buildSkeletonCard() {
    return Padding(
      padding: EdgeInsets.only(right: 15.w, left: 5.w),
      child: Column(
        children: [
          Container(
            width: 90.w,
            height: 90.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          SizedBox(height: 8.h),
          Container(width: 60.w, height: 12.h, color: Colors.white),
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
    final controller = Get.find<CustomerServiceController>();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Obx(() => Row(
        children: [
          _filterChip(
            controller.selectedRating.value > 0
                ? "${controller.selectedRating.value.toInt()}★"
                : "Rating",
            Icons.star_border,
            isActive: controller.selectedRating.value > 0,
            onTap: () => _showRatingPicker(controller),
            onClear: () {
              controller.selectedRating.value = 0.0;
              controller.fetchService();
            },
          ),
          SizedBox(width: 10.w),
          _filterChip(
            controller.maxPrice.value > 0
                ? "\$${controller.minPrice.value.toInt()}-\$${controller.maxPrice.value.toInt()}"
                : "Price",
            Icons.attach_money,
            isActive: controller.maxPrice.value > 0,
            onTap: () => _showPriceRangePicker(controller),
            onClear: () {
              controller.clearPrice();
              controller.priceRange.value = const RangeValues(1, 50000);
            },
          ),
          SizedBox(width: 10.w),
          _filterChip(
            controller.selectedDistance.value > 0
                ? "${controller.selectedDistance.value} km"
                : "Distance",
            Icons.location_on_outlined,
            isActive: controller.selectedDistance.value > 0,
            onTap: () => _showDistancePicker(controller),
            onClear: () => controller.resetDistance(),
          ),
          SizedBox(width: 10.w),
          // Updated Offers Chip
          _filterChip(
            "HasOffer", // Renamed label
            Icons.local_offer_outlined,
            isActive: controller.hasOffer.value,
            showArrow: false, // Removed dropdown arrow
            onTap: () => controller.toggleOffer(),
            onClear: () => controller.toggleOffer(),
          ),

          SizedBox(width: 10.w),
          // NEW: Home Service Chip
          _filterChip(
            "Home Service",
            Icons.home_repair_service_outlined,
            isActive: controller.homeService.value,
            showArrow: false,
            onTap: () => controller.toggleHomeService(),
            onClear: () => controller.toggleHomeService(),
          ),
        ],
      )),
    );
  }

  void _showRatingPicker(CustomerServiceController controller) {
    // Sync the slider starting point with the current active rating
    controller.ratingValue.value = controller.selectedRating.value > 0
        ? controller.selectedRating.value
        : 1.0;

    _showStyledBottomSheet(
      title: "Minimum Rating",
      child: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: controller.ratingValue.value.toStringAsFixed(1),
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D3826),
              ),
              Icon(Icons.star, color: Colors.amber, size: 28.sp),
              CustomText(text: " & Up", fontSize: 16.sp),
            ],
          ),
          SizedBox(height: 10.h),
          SliderTheme(
            data: SliderTheme.of(Get.context!).copyWith(
              activeTrackColor: const Color(0xFF1D3826),
              inactiveTrackColor: const Color(0xFF1D3826).withValues(alpha:0.1),
              thumbColor: const Color(0xFF1D3826),
              overlayColor: const Color(0xFF1D3826).withValues(alpha:0.2),
              valueIndicatorColor: const Color(0xFF1D3826),
              valueIndicatorTextStyle: const TextStyle(color: Colors.white),
            ),
            child: Slider(
              value: controller.ratingValue.value,
              min: 1.0,
              max: 5.0,
              divisions: 4, // Steps: 1, 2, 3, 4, 5
              label: controller.ratingValue.value.toInt().toString(),
              onChanged: (double value) {
                controller.ratingValue.value = value;
              },
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              controller.selectedRating.value = controller.ratingValue.value;
              controller.fetchService();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D3826),
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
            ),
            child: const CustomText(text: "Apply Rating", color: Colors.white),
          ),
          SizedBox(height: 10.h),
        ],
      )),
    );
  }

  void _showDistancePicker(CustomerServiceController controller) {
    _showStyledBottomSheet(
      title: "Search Radius",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [5, 10, 15, 20, 50].map((km) => ListTile(
          leading: const Icon(Icons.location_on, color: Color(0xFF1D3826)),
          title: CustomText(text: "Within $km km"),
          trailing: controller.selectedDistance.value == km
              ? const Icon(Icons.check, color: Color(0xFF1D3826)) : null,
          onTap: () {
            controller.selectedDistance.value = km;
            controller.fetchService();
            Get.back();
          },
        )).toList(),
      ),
    );
  }

// Helper to keep BottomSheets consistent
  void _showStyledBottomSheet({required String title, required Widget child}) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
        ),
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The drag handle
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 15.h), // Fixed here
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            CustomText(text: title, fontSize: 18.sp, fontWeight: FontWeight.bold),
            SizedBox(height: 10.h),
            child,
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showPriceRangePicker(CustomerServiceController controller) {
    _showStyledBottomSheet(
      title: "Select Price Range",
      child: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "\$${controller.priceRange.value.start.toInt()}",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
                CustomText(
                  text: "\$${controller.priceRange.value.end.toInt()}",
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          SliderTheme(
            data: SliderTheme.of(Get.context!).copyWith(
              activeTrackColor: const Color(0xFF1D3826),
              inactiveTrackColor: const Color(0xFF1D3826).withValues(alpha:0.1),
              thumbColor: const Color(0xFF1D3826),
              overlayColor: const Color(0xFF1D3826).withValues(alpha:0.2),
              rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: RangeSlider(
              values: controller.priceRange.value,
              min: 1,
              max: 50000,
              divisions: 500, // Moves in increments of 100
              labels: RangeLabels(
                controller.priceRange.value.start.round().toString(),
                controller.priceRange.value.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                controller.priceRange.value = values;
              },
            ),
          ),
          SizedBox(height: 20.h),
          // Apply Button
          ElevatedButton(
            onPressed: () {
              controller.updatePriceRange(controller.priceRange.value);
              controller.fetchService();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D3826),
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
            ),
            child: const CustomText(text: "Apply Filter", color: Colors.white),
          ),
          SizedBox(height: 10.h),
        ],
      )),
    );
  }

  Widget _filterChip(
      String label,
      IconData icon, {
        bool isActive = false,
        bool showArrow = true,
        required VoidCallback onTap,
        required VoidCallback onClear,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          // Use primary color if active, otherwise white
          color: isActive ? const Color(0xFF1D3826) : const Color(0XFFB5B475),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isActive ? const Color(0xFF1D3826) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
                icon,
                size: 16.sp,
                color: isActive ? Colors.white : Colors.black87
            ),
            SizedBox(width: 6.w),
            CustomText(
              text: label,
              fontSize: 12.sp,
              color: isActive ? Colors.white : Colors.black87,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            if (showArrow && !isActive) ...[
              SizedBox(width: 4.w),
              Icon(Icons.keyboard_arrow_down, size: 16.sp, color: Colors.black54),
            ],
            if (isActive) ...[
              SizedBox(width: 6.w),
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close, size: 14.sp, color: Colors.white),
              ),
            ]
          ],
        ),
      ),
    );
  }


  Widget _buildSubCategoryList(
      SubCategoryController subCtrl,
      CustomerServiceController serviceCtrl
      ) {
    return Obx(() {
      if (subCtrl.isLoading.value) return const Center(child: CircularProgressIndicator());
      if (subCtrl.subCategories.isEmpty) return const SizedBox.shrink();

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: subCtrl.subCategories.map((sub) {
            bool isSelected = serviceCtrl.selectedSubCategoryId.value == sub.id;

            return GestureDetector(
              onTap: () => serviceCtrl.filterBySubCategory(sub.id),
              child: Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: Column(
                  children: [
                    Container(
                      width: 85.w,
                      height: 85.w,
                      decoration: BoxDecoration(
                        // Color change based on selection
                        color: isSelected ? const Color(0xFF1D3826) : Colors.white,
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
                            // Tint icon if selected
                            color: isSelected ? Colors.white : null,
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                        ),
                      ),
                    ),
                    CustomText(
                      text: sub.name,
                      fontSize: 13.sp,
                      top: 10.h,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? const Color(0xFF1D3826) : Colors.black,
                    ),
                  ],
                ),
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
        bool isFavorite = false,
        VoidCallback? onTap,
        VoidCallback? onFavoriteTap,
        bool isFavoriteLoading = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220.w,
        margin: EdgeInsets.only(right: 20.w, bottom: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F0B2),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                  child: GestureDetector(
                    onTap: () {
                      if (!isFavoriteLoading && onFavoriteTap != null) {
                        HapticFeedback.mediumImpact(); // Added for better UX
                        onFavoriteTap();
                      }
                    },
                    child: CircleAvatar(
                      radius: 18.r,
                      backgroundColor: const Color(0xFF1D3826).withValues(alpha: 0.8),
                      child: isFavoriteLoading
                          ? SizedBox(
                        height: 15.h,
                        width: 15.h,
                        child: const CircularProgressIndicator(
                          color: Color(0xFFF1F0B2),
                          strokeWidth: 2,
                        ),
                      )
                          : Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: const Color(0xFFF1F0B2),
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 2. Info Section
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomText(
                          text: name,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                          color: const Color(0xFF000000),
                          maxLines: 1,
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
                      CustomText(
                        text: "\$$price",
                        fontSize: 20.sp,
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