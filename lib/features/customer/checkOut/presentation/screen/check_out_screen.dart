import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../vendor/orderFullFillment/data/order_full_fillment_response_model.dart';
import '../../../../vendor/orderFullFillment/presentation/controller/order_full_fillment_controller.dart';
import '../../../dealsPromos/data/customer_deals_promos_response_model.dart';
import '../../../dealsPromos/data/promo_validate_response_model.dart';
import '../../../dealsPromos/presentation/controller/customer_deals_promos_controller.dart';
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
  final promoController = Get.find<CustomerDealsPromosController>();

  final TextEditingController instructionController = TextEditingController();

  // Nullable to handle initial state and 'all disabled' case
  String? selectedSpeed;
  CustomerPromoCodeModel? selectedPromo;
  AppliedPromoResult? validatedPromo;
  String? promoErrorMessage;
  bool isValidatingPromo = false;

  @override
  void initState() {
    super.initState();
    _initializeSettings();

    /// fetch product promos for this vendor only
    promoController.fetchPromos(
      createdBy: vendorData.vendor.id,
      applicableFor: 'product',
    );
  }

  Future<void> _initializeSettings() async {
    // Fetch specific settings using the current vendor ID
    await fulfillmentController.fetchSettings(vendorId: vendorData.vendor.id);
    _setDefaultSelection();
  }



  // Logic to auto-select the first available enabled delivery method
  void _setDefaultSelection() {
    final attr = fulfillmentController.fulfillmentData.value;
    if (attr == null) return;

    bool isIntl = _isInternationalOrder();
    String? defaultMethod;

    setState(() {
      if (isIntl) {
        // For international orders, check shippingMethod
        if (attr.shippingMethod.standard.enabled) {
          defaultMethod = "Standard";
        } else if (attr.shippingMethod.turbo.enabled) {
          defaultMethod = "Turbo";
        } else if (attr.shippingMethod.basic.enabled) {
          defaultMethod = "Basic";
        }
      } else {
        // For domestic orders, check deliveryMethod
        if (attr.deliveryMethod.standard.enabled) {
          defaultMethod = "Standard";
        } else if (attr.deliveryMethod.turbo.enabled) {
          defaultMethod = "Turbo";
        } else if (attr.deliveryMethod.basic.enabled) {
          defaultMethod = "Basic";
        } else if (attr.deliveryMethod.pickup.enabled) {
          defaultMethod = "Pickup";
        } else if (attr.deliveryMethod.city.enabled) {
          defaultMethod = "City";
        }
      }
      selectedSpeed = defaultMethod;
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

        final attr = fulfillmentController.fulfillmentData.value;
        final vendorLocation = attr?.vendorCountry;
        final vendorCity = vendorLocation?.city ?? "";
        final vendorCountry = vendorLocation?.country ?? "";
        final methods = attr?.deliveryMethod;
        final shippingMethods = attr?.shippingMethod;

        final restrictedData = attr?.restrictedCountries;
        bool isRestricted = false;

        bool showRestrictionCard = restrictedData?.enabled ?? false;

        if (restrictedData != null && restrictedData.enabled) {
          // Compare current country with the restricted list (normalized to uppercase)
          String userCountry = checkoutController.selectedCountry.value.trim().toUpperCase();
          isRestricted = restrictedData.countries
              .map((c) => c.trim().toUpperCase())
              .contains(userCountry);
        }

        bool isIntl = _isInternationalOrder();
        bool hasAnyMethod = isIntl
            ? ((shippingMethods?.turbo.enabled ?? false) ||
                (shippingMethods?.standard.enabled ?? false) ||
                (shippingMethods?.basic.enabled ?? false))
            : ((methods?.turbo.enabled ?? false) ||
                (methods?.standard.enabled ?? false) ||
                (methods?.basic.enabled ?? false) ||
                (methods?.pickup.enabled ?? false) ||
                (methods?.city.enabled ?? false));

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              if (isRestricted) _buildRestrictionBanner(checkoutController.selectedCountry.value),

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

              if (showRestrictionCard) ...[
                _buildRestrictedCountriesCard(restrictedData!.countries),
                SizedBox(height: 25.h),
              ],

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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                  children: [
                    if (attr != null) ...[
                      // Logic: Pick the correct display data based on international status
                      // Use the pre-calculated isIntl variable for consistency

                      // 1. TURBO
                      if (isIntl
                          ? attr.shippingMethod.turbo.enabled
                          : attr.deliveryMethod.turbo.enabled)
                        _speedCard(
                          "Turbo",
                          isIntl ? attr.shippingMethod.turbo.deliveryTime : attr.deliveryMethod.turbo.deliveryTime,
                          "\$${isIntl ? attr.shippingMethod.turbo.price : attr.deliveryMethod.turbo.price}",
                          true,
                        ),

                      // 2. STANDARD
                      if (isIntl
                          ? attr.shippingMethod.standard.enabled
                          : attr.deliveryMethod.standard.enabled)
                        _speedCard(
                          "Standard",
                          isIntl ? attr.shippingMethod.standard.deliveryTime : attr.deliveryMethod.standard.deliveryTime,
                          "\$${isIntl ? attr.shippingMethod.standard.price : attr.deliveryMethod.standard.price}",
                          false,
                        ),

                      // 3. BASIC
                      if (isIntl
                          ? attr.shippingMethod.basic.enabled
                          : attr.deliveryMethod.basic.enabled)
                        _speedCard(
                          "Basic",
                          isIntl ? attr.shippingMethod.basic.deliveryTime : attr.deliveryMethod.basic.deliveryTime,
                          "\$${isIntl ? attr.shippingMethod.basic.price : attr.deliveryMethod.basic.price}",
                          false,
                        ),

                      // 4. PICKUP (Hidden if International)
                      if (!isIntl && attr.deliveryMethod.pickup.enabled)
                        _speedCard(
                          "Pickup",
                          "Collect in store",
                          "\$${attr.deliveryMethod.pickup.price}",
                          false,
                        ),

                      // 5. CITY (Hidden if International)
                      if (!isIntl && attr.deliveryMethod.city.enabled)
                        _speedCard(
                          "City",
                          attr.deliveryMethod.city.deliveryTime,
                          "\$${attr.deliveryMethod.city.price}",
                          false,
                        ),
                    ],
                  ],
                  ),
                ),

                // Show warning if Standard method is not enabled but other methods are
                if (selectedSpeed == null) ...[
                  SizedBox(height: 15.h),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.warning, size: 20.sp),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CustomText(
                            text: isIntl 
                                ? "No international shipping methods available for this vendor."
                                : "No delivery methods available for this vendor.",
                            fontSize: 12.sp,
                            color: AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],

              SizedBox(height: 30.h),
              CustomText(text: "Summary", fontSize: 22.sp, fontWeight: FontWeight.bold),
              SizedBox(height: 15.h),
              _buildSummaryRow(Icons.storefront, "${vendorData.vendor.businessName} | ${vendorData.itemCount} items"),

              if (vendorCity.isNotEmpty || vendorCountry.isNotEmpty) ...[
                SizedBox(height: 10.h),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06), // soft highlight
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.public, // better than location pin for country meaning
                          size: 16.sp,
                          color: AppColors.primaryDark,
                        ),
                      ),

                      SizedBox(width: 10.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Vendor Location",
                              fontSize: 10.sp,
                              color: AppColors.geryColor,
                            ),
                            CustomText(
                              text: [
                                if (vendorCity.isNotEmpty) vendorCity,
                                if (vendorCountry.isNotEmpty) vendorCountry,
                              ].join(", "),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 25.h),

              // --- 5. PROMO SECTION (same pattern as booking confirm) ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Promo (optional)",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.iconPrimary,
                    bottom: 8.h,
                  ),
                  CustomText(
                    text: validatedPromo != null
                        ? "Selected — included in total. Change anytime."
                        : "Skip if you want — or tap below to add a store code.",
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    bottom: 10.h,
                  ),
                  _buildCheckoutPromoCard(),
                  if (promoErrorMessage != null) ...[
                    SizedBox(height: 8.h),
                    CustomText(
                      text: promoErrorMessage!,
                      fontSize: 12.sp,
                      color: AppColors.error,
                    ),
                  ],
                  SizedBox(height: 25.h),
                ],
              ),


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
              _priceRow(
                "Service Fee (4%)",
                AppConstants.serviceFeeFor(vendorData.subtotal).toStringAsFixed(2),
              ),
              _priceRow(
                "GST/Tax (5%)",
                AppConstants.gstTaxFor(vendorData.subtotal).toStringAsFixed(2),
              ),
              _priceRow("Delivery Fee", _getSelectedDeliveryPrice().toStringAsFixed(2)),

              SizedBox(height: 15.h),
              _buildTotalSection(),

              SizedBox(height: 30.h),

              // Place Order Button
              Obx(() {
                // Re-calculate restriction inside this small Obx for button state
                final restrictedData = fulfillmentController.fulfillmentData.value?.restrictedCountries;
                bool isRestricted = false;
                if (restrictedData != null && restrictedData.enabled) {
                  isRestricted = restrictedData.countries
                      .map((c) => c.trim().toUpperCase())
                      .contains(checkoutController.selectedCountry.value.trim().toUpperCase());
                }

                return CustomButton(
                  text: checkoutController.isPlacingOrder.value ? "Processing..." : "Place Order",
                  // Add isRestricted check here
                  onTap: (checkoutController.isPlacingOrder.value || !hasAnyMethod || isRestricted)
                      ? null
                      : () => _handleOrderPlacement(),
                );
              }),
              SizedBox(height: 40.h),
            ],
          ),
        );
      }),
    );
  }

  // --- UI Component Helpers ---

  Widget _buildEstimatedTimeHeader(GetDeliveryMethodConfig? methods) {
    final attr = fulfillmentController.fulfillmentData.value;
    bool isIntl = _isInternationalOrder();
    String timeRange = "";

    if (selectedSpeed == "Turbo") {
      timeRange = isIntl 
          ? (attr?.shippingMethod.turbo.deliveryTime ?? "")
          : (methods?.turbo.deliveryTime ?? "");
    } else if (selectedSpeed == "Basic") {
      timeRange = isIntl 
          ? (attr?.shippingMethod.basic.deliveryTime ?? "")
          : (methods?.basic.deliveryTime ?? "");
    } else if (selectedSpeed == "City") {
      timeRange = methods?.city.deliveryTime ?? "";
    } else if (selectedSpeed == "Pickup") {
      timeRange = "Ready for pickup";
    } else {
      // Standard or default
      timeRange = isIntl 
          ? (attr?.shippingMethod.standard.deliveryTime ?? "")
          : (methods?.standard.deliveryTime ?? "");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, size: 20.sp, color: Colors.black),
            SizedBox(width: 8.w),
            CustomText(text: "Estimated Delivery Time", fontSize: 12.sp, fontWeight: FontWeight.w600),
          ],
        ),
        CustomText(text: timeRange, fontSize: 12.sp, fontWeight: FontWeight.bold),
      ],
    );
  }

  Widget _speedCard(String title, String desc, String price, bool hasPromo) {
    bool isSelected = selectedSpeed == title;
    return GestureDetector(
      onTap: () => setState(() => selectedSpeed = title),
      child: Container(
        width: 82.w,
        margin: EdgeInsets.only(right: 10.w),
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
      promoCode: validatedPromo?.code ?? checkoutController.appliedPromo.value?.code,
    );
  }

  void _clearPromo() {
    setState(() {
      selectedPromo = null;
      validatedPromo = null;
      promoErrorMessage = null;
    });
    checkoutController.clearAppliedPromo();
  }

  Future<void> _applyPromoCode(String code) async {
    setState(() {
      isValidatingPromo = true;
      promoErrorMessage = null;
    });

    final result = await promoController.validatePromoCode(
      code: code,
      subtotal: vendorData.subtotal,
      vendorId: vendorData.vendor.id,
      showSuccessSnack: true,
    );

    if (!mounted) return;

    setState(() {
      isValidatingPromo = false;
      if (result != null) {
        validatedPromo = result;
        checkoutController.setAppliedPromo(result);
        try {
          selectedPromo = promoController.promoList.firstWhere(
            (p) => p.code.toUpperCase() == result.code.toUpperCase(),
          );
        } catch (_) {
          selectedPromo = null;
        }
        promoErrorMessage = null;
      } else {
        validatedPromo = null;
        selectedPromo = null;
        checkoutController.clearAppliedPromo();
        promoErrorMessage = 'This promo could not be applied. Try another code.';
      }
    });
  }

  Widget _buildCheckoutPromoCard() {
    final hasPromo = validatedPromo != null;
    return GestureDetector(
      onTap: isValidatingPromo ? null : _showPromoBottomSheet,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: hasPromo
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: promoErrorMessage != null
                ? AppColors.error
                : hasPromo
                    ? AppColors.iconPrimary
                    : AppColors.cardBorder,
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isValidatingPromo
                  ? Icons.hourglass_top
                  : hasPromo
                      ? Icons.check_circle
                      : Icons.local_offer_outlined,
              color: AppColors.iconPrimary,
              size: 22.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: isValidatingPromo
                        ? "Checking promo..."
                        : hasPromo
                            ? validatedPromo!.successLabel
                            : "Add promo code",
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.iconPrimary,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: hasPromo
                        ? "Ready to use on payment"
                        : "Tap to select or enter a code",
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            if (hasPromo)
              GestureDetector(
                onTap: _clearPromo,
                child: const Icon(
                  Icons.cancel,
                  color: AppColors.error,
                  size: 20,
                ),
              )
            else
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.navigationInactive,
              ),
          ],
        ),
      ),
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
            Expanded(
              child: CustomText(
                text: text,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textPrimary),
          ],
        ),
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

  double _getDiscountAmount() {
    if (validatedPromo != null) {
      return validatedPromo!.discountAmount;
    }
    if (selectedPromo == null) return 0.0;
    return double.parse(
      (vendorData.subtotal * (selectedPromo!.discountPercentage / 100))
          .toStringAsFixed(2),
    );
  }

  Widget _buildTotalSection() {
    double tip = _getCalculatedTip();
    double deliveryPrice = _getSelectedDeliveryPrice(); // This will be 0 if free shipping applies
    double freeShippingSaved = _getFreeShippingDiscount();
    double discount = _getDiscountAmount();
    final double serviceFee = AppConstants.serviceFeeFor(vendorData.subtotal);
    final double gstTax = AppConstants.gstTaxFor(vendorData.subtotal);

    // Final Total: subtotal + 4% fee + 5% GST + delivery + tip - discount
    double total = (vendorData.subtotal + serviceFee + gstTax + deliveryPrice + tip) - discount;

    return Column(
      children: [
        // Show Free Shipping row if applicable
        if (freeShippingSaved > 0)
          _priceRow("Conditional Free Shipping", "-${freeShippingSaved.toStringAsFixed(2)}", isDiscount: true),

        if (discount > 0)
          _priceRow("Promo Discount", "-${discount.toStringAsFixed(2)}", isDiscount: true),

        if (tip > 0) _priceRow("Tip", tip.toStringAsFixed(2)),

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

// Update _priceRow to handle green color for discounts
  Widget _priceRow(String label, String price, {bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: label, fontSize: 12.sp, color: const Color(0XFF4E5760)),
          CustomText(
              text: isDiscount ? "-\$$price" : "\$$price",
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDiscount ? Colors.green : const Color(0XFF4E5760)
          ),
        ],
      ),
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
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 2))
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

  void _showPromoBottomSheet() {
    Get.bottomSheet(
      _CheckoutPromoSheet(
        initialCode: validatedPromo?.code ?? '',
        promoController: promoController,
        onApply: (code) async {
          Get.back();
          await _applyPromoCode(code);
        },
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
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
                  color: AppColors.surfaceVariant.withValues(alpha: 0.5),
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
                  fillColor: AppColors.surfaceVariant.withValues(alpha: 0.3),
                  contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
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


  Widget _buildRestrictionBanner(String countryName) {
    return Container(
      margin: EdgeInsets.only(top: 15.h, bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.gpp_bad_outlined, color: AppColors.error, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Delivery Restricted",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
                CustomText(
                  text: "The vendor does not ship to $countryName. Please change your address to continue.",
                  fontSize: 11.sp,
                  color: AppColors.error.withValues(alpha: 0.8),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
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
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
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

  Widget _buildRestrictedCountriesCard(List<String> countries) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.public_off, size: 18.sp, color: AppColors.error),
              SizedBox(width: 8.w),
              CustomText(
                text: "Shipping Restrictions",
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomText(
            text: "This vendor currently does not deliver to the following locations:",
            fontSize: 11.sp,
            color: AppColors.geryColor,
            bottom: 12.h,
          ),
          if (countries.isEmpty)
            CustomText(text: "No specific country restrictions set.", fontSize: 11.sp, color: Colors.black54)
          else
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: countries.map((country) => Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.1)),
                ),
                child: CustomText(
                  text: country.toUpperCase(),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }

  // Helper to check if Conditional Free Shipping applies
  bool _isFreeShippingApplied() {
    final costs = fulfillmentController.fulfillmentData.value?.costsAndFees;
    if (costs == null) return false;

    final freeShipping = costs.conditionalFreeShipping;
    if (freeShipping.enabled && vendorData.subtotal >= freeShipping.minOrderAmount) {
      // Note: Pickup is already $0, so we usually apply this to paid delivery methods
      return selectedSpeed != "Pickup";
    }
    return false;
  }

  double _getSelectedDeliveryPrice() {
    if (_isFreeShippingApplied()) return 0.0;

    final attr = fulfillmentController.fulfillmentData.value;
    if (attr == null || selectedSpeed == null) return 0.0;

    bool isIntl = _isInternationalOrder();

    switch (selectedSpeed) {
      case "Turbo":
        return isIntl
            ? attr.shippingMethod.turbo.price.toDouble()
            : attr.deliveryMethod.turbo.price.toDouble();
      case "Basic":
        return isIntl
            ? attr.shippingMethod.basic.price.toDouble()
            : attr.deliveryMethod.basic.price.toDouble();
      case "Pickup":
        return attr.deliveryMethod.pickup.price.toDouble();
      case "City":
        return attr.deliveryMethod.city.price.toDouble();
      default: // Standard
        return isIntl
            ? attr.shippingMethod.standard.price.toDouble()
            : attr.deliveryMethod.standard.price.toDouble();
    }
  }

// Helper to get the actual "saved" amount for UI display
  double _getFreeShippingDiscount() {
    if (!_isFreeShippingApplied()) return 0.0;

    final attr = fulfillmentController.fulfillmentData.value;
    if (attr == null || selectedSpeed == null) return 0.0;

    bool isIntl = _isInternationalOrder();

    switch (selectedSpeed) {
      case "Turbo":
        return isIntl
            ? attr.shippingMethod.turbo.price.toDouble()
            : attr.deliveryMethod.turbo.price.toDouble();
      case "Basic":
        return isIntl
            ? attr.shippingMethod.basic.price.toDouble()
            : attr.deliveryMethod.basic.price.toDouble();
      case "City":
        return attr.deliveryMethod.city.price.toDouble();
      default: // Standard
        return isIntl
            ? attr.shippingMethod.standard.price.toDouble()
            : attr.deliveryMethod.standard.price.toDouble();
    }
  }

  bool _isInternationalOrder() {
    final attr = fulfillmentController.fulfillmentData.value;
    if (attr == null) return false;

    final userCountry =
    checkoutController.selectedCountry.value.trim().toUpperCase();

    final vendorCountry =
    (attr.vendorCountry.country).trim().toUpperCase();

    if (vendorCountry.isEmpty || userCountry.isEmpty) return false;

    return userCountry != vendorCountry;
  }


}

/// Owns TextEditingController so it is never disposed while the sheet is open.
class _CheckoutPromoSheet extends StatefulWidget {
  const _CheckoutPromoSheet({
    required this.initialCode,
    required this.promoController,
    required this.onApply,
  });

  final String initialCode;
  final CustomerDealsPromosController promoController;
  final Future<void> Function(String code) onApply;

  @override
  State<_CheckoutPromoSheet> createState() => _CheckoutPromoSheetState();
}

class _CheckoutPromoSheetState extends State<_CheckoutPromoSheet> {
  late final TextEditingController enterController;

  @override
  void initState() {
    super.initState();
    enterController = TextEditingController(text: widget.initialCode);
  }

  @override
  void dispose() {
    enterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Obx(() {
          final list = widget.promoController.promoList;
          final validating = widget.promoController.isValidating.value;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                color: AppColors.cardBorder,
              ),
              SizedBox(height: 16.h),
              CustomText(
                text: "Add promo code",
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.iconPrimary,
              ),
              SizedBox(height: 6.h),
              CustomText(
                text:
                    "Pick a store offer or paste a code. We'll check it before pay.",
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: enterController,
                hintText: "Enter promo code",
                contenpaddingVertical: 12.h,
              ),
              SizedBox(height: 12.h),
              CustomButton(
                text: validating ? "Checking..." : "Apply to order",
                height: 44.h,
                color: AppColors.buttonPrimary,
                textColor: AppColors.textOnDark,
                onTap: validating
                    ? () {}
                    : () async {
                        final code = enterController.text.trim();
                        if (code.isEmpty) {
                          AppSnackbar.error(
                            'Please enter a promo code',
                            title: 'Promo',
                          );
                          return;
                        }
                        await widget.onApply(code);
                      },
              ),
              if (list.isNotEmpty) ...[
                SizedBox(height: 18.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: "Available for this store",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.iconPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 220.h),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: list.length,
                    separatorBuilder: (_, _) =>
                        const Divider(color: AppColors.divider),
                    itemBuilder: (context, index) {
                      final promo = list[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.local_offer_outlined,
                          color: AppColors.iconPrimary,
                        ),
                        title: CustomText(
                          text: promo.code,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        subtitle: CustomText(
                          text:
                              "${promo.discountPercentage}% off · min \$${promo.minPurchaseAmount}",
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                        trailing: validating
                            ? SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : CustomText(
                                text: "Use",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.iconPrimary,
                              ),
                        onTap: validating
                            ? null
                            : () async {
                                enterController.text = promo.code;
                                await widget.onApply(promo.code);
                              },
                      );
                    },
                  ),
                ),
              ] else ...[
                SizedBox(height: 16.h),
                CustomText(
                  text: "No listed offers — you can still paste a code above.",
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  textAlign: TextAlign.center,
                ),
              ],
              SizedBox(height: 12.h),
            ],
          );
        }),
      ),
    );
  }
}
