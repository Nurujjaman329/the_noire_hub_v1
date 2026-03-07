import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../vendor/orderFullFillment/data/order_full_fillment_response_model.dart';
import '../../../../vendor/orderFullFillment/presentation/controller/order_full_fillment_controller.dart';
import '../../../multiVendorCartScreen/data/multi_vendor_cart_response_model.dart';
import '../controller/check_out_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // 1. Get arguments and Controllers
  final CartVendor vendorData = Get.arguments;
  final checkoutController = Get.find<CheckOutController>();
  final fulfillmentController = Get.find<OrderFullFillmentController>();

  final TextEditingController instructionController = TextEditingController();

  // Nullable to handle initial state and 'all disabled' case
  String? selectedSpeed;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    // Fetch specific settings using the current vendor ID
    await fulfillmentController.fetchSettings(vendorId: vendorData.vendor.id);
    _setDefaultSelection();
  }

  // Logic to auto-select the first available enabled delivery method
  void _setDefaultSelection() {
    final methods = fulfillmentController.fulfillmentData.value?.deliveryMethod;
    if (methods == null) return;

    setState(() {
      if (methods.standard.enabled) {
        selectedSpeed = "Standard";
      } else if (methods.turbo.enabled) {
        selectedSpeed = "Turbo";
      } else if (methods.basic.enabled) {
        selectedSpeed = "Basic";
      } else if (methods.pickup.enabled) {
        selectedSpeed = "Pickup";
      } else {
        selectedSpeed = null;
      }
    });
  }

  @override
  void dispose() {
    instructionController.dispose();
    super.dispose();
  }

  // --- Helpers for Calculation & API Payload ---

  String _getApiDeliveryMethod() {
    if (selectedSpeed == null) return "standard";
    return selectedSpeed!.toLowerCase();
  }

  double _getSelectedDeliveryPrice() {
    final methods = fulfillmentController.fulfillmentData.value?.deliveryMethod;
    if (methods == null || selectedSpeed == null) return 0.0;

    switch (selectedSpeed) {
      case "Turbo": return methods.turbo.price.toDouble();
      case "Basic": return methods.basic.price.toDouble();
      case "Pickup": return methods.pickup.price.toDouble();
      default: return methods.standard.price.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
            text: "Checkout",
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary),
      ),
      body: Obx(() {
        if (fulfillmentController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        final methods = fulfillmentController.fulfillmentData.value?.deliveryMethod;
        bool hasAnyMethod = (methods?.turbo.enabled ?? false) ||
            (methods?.standard.enabled ?? false) ||
            (methods?.basic.enabled ?? false) ||
            (methods?.pickup.enabled ?? false);

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // --- 1. ADDRESS SEARCH SECTION (Dynamic from Mixin) ---
              CustomText(text: "Add Address", fontSize: 18.sp, fontWeight: FontWeight.bold, bottom: 15.h),
              CustomTextField(
                controller: checkoutController.searchController,
                labelText: "Search Location",
                hintText: "Enter neighborhood or street",
                prefixIcon: Icons.search,
                onChanged: (value) => checkoutController.onSearchChanged(value),
              ),

              // Floating Suggestion List
              Obx(() => checkoutController.placePredictions.isNotEmpty
                  ? Container(
                margin: EdgeInsets.only(top: 5.h),
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: checkoutController.placePredictions.length,
                  itemBuilder: (context, index) {
                    final item = checkoutController.placePredictions[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on_outlined, size: 18),
                      title: Text(item['description'], style: TextStyle(fontSize: 13.sp)),
                      onTap: () => checkoutController.selectPrediction(item),
                    );
                  },
                ),
              )
                  : const SizedBox.shrink()),

              SizedBox(height: 20.h),

              // --- 2. MAP PINNING SECTION ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(text: "Pin Location", fontSize: 14.sp, fontWeight: FontWeight.w600),
                  GestureDetector(
                    onTap: () => checkoutController.getCurrentLocation(),
                    child: Row(
                      children: [
                        const Icon(Icons.my_location, size: 14, color: Color(0XFFB5B475)),
                        SizedBox(width: 4.w),
                        CustomText(
                          text: "Use Current Location",
                          fontSize: 12.sp,
                          color: const Color(0XFFB5B475),
                          fontWeight: FontWeight.w600,
                          textDecoration: TextDecoration.underline,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              Container(
                height: 200.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Obx(() => GoogleMap(
                    initialCameraPosition: CameraPosition(target: checkoutController.selectedLatLng.value, zoom: 14),
                    onMapCreated: checkoutController.onMapCreated,
                    onTap: (latLng) => checkoutController.updateLocation(latLng),
                    markers: {
                      Marker(
                        markerId: const MarkerId("selected"),
                        position: checkoutController.selectedLatLng.value,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                      ),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  )),
                ),
              ),

              SizedBox(height: 15.h),

              // --- 3. SELECTED ADDRESS PREVIEW ---
              Obx(() => Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0XFF1D3826)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CustomText(
                        text: checkoutController.currentAddressString.value.isEmpty ? "Fetching address..." : checkoutController.currentAddressString.value,
                        fontSize: 13.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              )),

              SizedBox(height: 25.h),

              // --- 4. DELIVERY INSTRUCTIONS ---
              CustomText(text: "Delivery Instructions", fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black),
              SizedBox(height: 10.h),
              TextField(
                controller: instructionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Add details here (e.g. Leave at door)",
                  hintStyle: TextStyle(color: AppColors.geryColor, fontSize: 12.sp),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r), borderSide: BorderSide.none),
                ),
              ),

              if (hasAnyMethod) ...[
                SizedBox(height: 25.h),
                _buildEstimatedTimeHeader(methods),
                SizedBox(height: 15.h),

                // --- 5. SPEED CARDS ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (methods!.turbo.enabled) _speedCard("Turbo", methods.turbo.deliveryTime, "\$${methods.turbo.price}", true),
                    if (methods.standard.enabled) _speedCard("Standard", methods.standard.deliveryTime, "\$${methods.standard.price}", false),
                    if (methods.basic.enabled) _speedCard("Basic", methods.basic.deliveryTime, "\$${methods.basic.price}", false),
                    if (methods.pickup.enabled) _speedCard("Pickup", "Collect in store", "\$${methods.pickup.price}", false),
                  ],
                ),
              ],

              SizedBox(height: 30.h),
              CustomText(text: "Summary", fontSize: 22.sp, fontWeight: FontWeight.bold),
              SizedBox(height: 15.h),
              _buildSummaryRow(Icons.storefront, "${vendorData.vendor.businessName} | ${vendorData.itemCount} items"),



              // --- TIP SECTION ---
              SizedBox(height: 25.h),
              CustomText(text: "Add a Tip", fontSize: 16.sp, fontWeight: FontWeight.bold),
              SizedBox(height: 12.h),
              Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _tipOption(0, "Flat \$5", 5.0, true),
                    SizedBox(width: 10.w),
                    _tipOption(1, "Flat \$10", 10.0, true),
                    SizedBox(width: 10.w),
                    _tipOption(2, "5%", 0.05, false),
                    SizedBox(width: 10.w),
                    _tipOption(3, "10%", 0.10, false),
                    SizedBox(width: 10.w),
                    _tipOption(4, "Custom", 0.0, true, isCustom: true),
                  ],
                ),
              )),

              SizedBox(height: 30.h),
              // --- 6. PRICE DETAILS ---
              SizedBox(height: 25.h),
              _priceRow("Subtotal", vendorData.subtotal.toStringAsFixed(2)),
              _priceRow("Delivery Fee", _getSelectedDeliveryPrice().toStringAsFixed(2)),

              SizedBox(height: 15.h),
              _buildTotalSection(),

              SizedBox(height: 30.h),

              // Place Order Button
              Obx(() => CustomButton(
                text: checkoutController.isPlacingOrder.value ? "Processing..." : "Place Order",
                onTap: (checkoutController.isPlacingOrder.value || !hasAnyMethod) ? null : () => _handleOrderPlacement(),
              )),
              SizedBox(height: 40.h),
            ],
          ),
        );
      }),
    );
  }

  // --- UI Component Helpers ---

  Widget _buildEstimatedTimeHeader(GetDeliveryMethodConfig? methods) {
    String timeRange = "";
    if (selectedSpeed == "Turbo") {
      timeRange = methods?.turbo.deliveryTime ?? "";
    } else if (selectedSpeed == "Basic") {timeRange = methods?.basic.deliveryTime ?? "";}
    else if (selectedSpeed == "Pickup") {
      timeRange = "Ready for pickup";
    }
    else {
      timeRange = methods?.standard.deliveryTime ?? "";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, size: 20.sp, color: Colors.black),
            SizedBox(width: 8.w),
            CustomText(text: "Estimated Delivery Time", fontSize: 14.sp, fontWeight: FontWeight.w600),
          ],
        ),
        CustomText(text: timeRange, fontSize: 14.sp, fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget _speedCard(String title, String desc, String price, bool hasPromo) {
    bool isSelected = selectedSpeed == title;
    return GestureDetector(
      onTap: () => setState(() => selectedSpeed = title),
      child: Container(
        width: 82.w,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceVariant : AppColors.surfaceVariant.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: isSelected ? AppColors.chipActive : Colors.transparent, width: 2),
        ),
        child: Column(
          children: [
            Icon(title == "Turbo" ? Icons.bolt : (title == "Pickup" ? Icons.store : Icons.hourglass_empty),
                size: 18.sp, color: title == "Turbo" ? Colors.orange : (title == "Pickup" ? AppColors.primary : Colors.grey)),
            SizedBox(height: 5.h),
            CustomText(text: title, fontSize: 11.sp, fontWeight: FontWeight.bold),
            CustomText(text: desc, fontSize: 8.sp, maxLines: 2, textAlign: TextAlign.center, color: Colors.black54),
            SizedBox(height: 5.h),
            CustomText(text: price, fontSize: 11.sp, fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }


  void _handleOrderPlacement() {
    final List<Map<String, dynamic>> apiItems = vendorData.items.map((item) {
      // 1. Start with the common fields
      final Map<String, dynamic> itemMap = {
        "productId": item.product.id.toString(),
        "quantity": item.quantity,
      };

      // 2. Only add variantId if it is not null and not empty
      if (item.variantId != null && item.variantId.toString().isNotEmpty) {
        itemMap["variantId"] = item.variantId.toString();
      }

      return itemMap;
    }).toList();

    // 3. Call the controller with the clean items list
    checkoutController.placeOrder(
      vendorId: vendorData.vendor.id.toString(),
      items: apiItems,
      deliveryMethod: _getApiDeliveryMethod(),
      address: {
        "street": checkoutController.currentAddressString.value,
        "city": checkoutController.selectedCity.value,
        "state": "Ontario",
        "country": checkoutController.selectedCountry.value,
        "location": {
          "type": "Point",
          "coordinates": [
            checkoutController.selectedLatLng.value.longitude,
            checkoutController.selectedLatLng.value.latitude
          ]
        }
      },
      instructions: instructionController.text.trim(),
      tip: _getCalculatedTip(),
      // promoCode: "EID77",
    );
  }

  Widget _buildSummaryRow(IconData icon, String text, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 24.sp, color: AppColors.iconPrimary),
            SizedBox(width: 15.w),
            Expanded(child: CustomText(text: text, fontSize: 13.sp, fontWeight: FontWeight.w500, textAlign: TextAlign.start)),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textPrimary),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String price) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: label, fontSize: 12.sp, color: const Color(0XFF4E5760)),
          CustomText(text: "\$$price", fontSize: 12.sp, fontWeight: FontWeight.w600, color: const Color(0XFF4E5760)),
        ],
      ),
    );
  }


  // Helper to calculate tip based on type
  double _getCalculatedTip() {
    if (checkoutController.isFlatTip.value) {
      return checkoutController.tipValue.value;
    } else {
      // Percentage calculation: subtotal * percentage
      return vendorData.subtotal * checkoutController.tipValue.value;
    }
  }

// Updated Total Section
  Widget _buildTotalSection() {
    double tip = _getCalculatedTip();
    double total = vendorData.subtotal + _getSelectedDeliveryPrice() + tip;

    return Column(
      children: [
        if (tip > 0) _priceRow("Driver Tip", tip.toStringAsFixed(2)),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: "Total", fontSize: 18.sp, fontWeight: FontWeight.bold),
            CustomText(text: "\$${total.toStringAsFixed(2)}", fontSize: 18.sp, fontWeight: FontWeight.bold),
          ],
        ),
      ],
    );
  }

// Tip Card Widget
  Widget _tipOption(int index, String label, double value, bool isFlat, {bool isCustom = false}) {
    bool isSelected = checkoutController.selectedTipIndex.value == index;
    return GestureDetector(
      onTap: () {
        if (isCustom) {
          _showCustomTipDialog();
        } else {
          checkoutController.setTip(value, isFlat, index);
        }
      },
      child: Container(
        width: 75.w, // Matching speed card logic
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceVariant : Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
              color: isSelected ? AppColors.chipActive : Colors.grey.shade200,
              width: 1.5
          ),
          boxShadow: isSelected ? [] : [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          children: [
            Icon(
              isCustom ? Icons.edit_note : Icons.volunteer_activism_outlined,
              size: 16.sp,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            SizedBox(height: 4.h),
            CustomText(
              text: label,
              fontSize: 11.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.textPrimary : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomTipDialog() {
    final TextEditingController customTipC = TextEditingController();
    RxBool isFlatSelected = true.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        backgroundColor: AppColors.white,
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              CustomText(
                text: "Custom Tip",
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                bottom: 8.h,
              ),
              CustomText(
                text: "How much would you like to tip the driver?",
                fontSize: 13.sp,
                color: Colors.grey,
                bottom: 24.h,
              ),

              // Segmented Toggle (Modern look)
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Obx(() => Row(
                  children: [
                    _buildToggleItem("Flat (\$)", isFlatSelected.value, () => isFlatSelected.value = true),
                    _buildToggleItem("Percent (%)", !isFlatSelected.value, () => isFlatSelected.value = false),
                  ],
                )),
              ),

              SizedBox(height: 24.h),

              // Modern Input Field
              Obx(() => TextField(
                controller: customTipC,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "0.00",
                  prefixText: isFlatSelected.value ? "\$ " : null,
                  suffixText: isFlatSelected.value ? null : " %",
                  prefixStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18.sp),
                  suffixStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18.sp),
                  filled: true,
                  fillColor: AppColors.surfaceVariant.withOpacity(0.3),
                  contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: AppColors.primary.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              )),

              SizedBox(height: 24.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: CustomText(text: "Cancel", color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      text: "Apply",
                      onTap: () {
                        double val = double.tryParse(customTipC.text) ?? 0.0;
                        if (val > 0) {
                          double finalVal = isFlatSelected.value ? val : (val / 100);
                          checkoutController.setTip(finalVal, isFlatSelected.value, 4);
                        }
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Helper widget for the toggle items
  Widget _buildToggleItem(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
                : [],
          ),
          child: Center(
            child: CustomText(
              text: label,
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}