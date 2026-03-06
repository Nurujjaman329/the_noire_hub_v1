import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../data/order_full_fillment_post_body.dart';
import '../../data/order_full_fillment_response_model.dart';
import '../controller/order_full_fillment_controller.dart';


class OrderFulfillmentScreen extends StatefulWidget {
  const OrderFulfillmentScreen({super.key});

  @override
  State<OrderFulfillmentScreen> createState() => _OrderFulfillmentScreenState();
}

class _OrderFulfillmentScreenState extends State<OrderFulfillmentScreen> {
  final controller = Get.find<OrderFullFillmentController>();

  // State Maps
  final Map<String, bool> _shippingEnabled = {"Turbo": false, "Standard": false, "Basic": false};
  final Map<String, bool> _deliveryEnabled = {"Turbo": false, "Standard": false, "Basic": false, "Pickup": false};
  final Map<String, bool> _costsEnabled = {"Vendor": false, "Customer": false, "Free": false};

  // Controllers for Prices
  final Map<String, TextEditingController> _shippingPrices = {
    "Turbo": TextEditingController(), "Standard": TextEditingController(), "Basic": TextEditingController(),
  };
  final Map<String, TextEditingController> _deliveryPrices = {
    "Turbo": TextEditingController(), "Standard": TextEditingController(), "Basic": TextEditingController(), "Pickup": TextEditingController(),
  };

  // Controllers for Times
  final Map<String, TextEditingController> _shippingTimes = {
    "Turbo": TextEditingController(), "Standard": TextEditingController(), "Basic": TextEditingController(),
  };
  final Map<String, TextEditingController> _deliveryTimes = {
    "Turbo": TextEditingController(), "Standard": TextEditingController(), "Basic": TextEditingController(),
  };

  final TextEditingController _freeShippingMinAmount = TextEditingController();

  @override
  void initState() {
    super.initState();
    ever(controller.fulfillmentData, (data) {
      if (data != null) _populateData(data);
    });
    if (controller.fulfillmentData.value != null) {
      _populateData(controller.fulfillmentData.value!);
    }
  }

  void _populateData(GetOrderFulfillmentAttributes attr) {
    setState(() {
      _shippingEnabled["Turbo"] = attr.shippingMethod.turbo.enabled;
      _shippingPrices["Turbo"]!.text = attr.shippingMethod.turbo.price.toString();
      _shippingTimes["Turbo"]!.text = attr.shippingMethod.turbo.deliveryTime;

      _shippingEnabled["Standard"] = attr.shippingMethod.standard.enabled;
      _shippingPrices["Standard"]!.text = attr.shippingMethod.standard.price.toString();
      _shippingTimes["Standard"]!.text = attr.shippingMethod.standard.deliveryTime;

      _shippingEnabled["Basic"] = attr.shippingMethod.basic.enabled;
      _shippingPrices["Basic"]!.text = attr.shippingMethod.basic.price.toString();
      _shippingTimes["Basic"]!.text = attr.shippingMethod.basic.deliveryTime;

      _deliveryEnabled["Turbo"] = attr.deliveryMethod.turbo.enabled;
      _deliveryPrices["Turbo"]!.text = attr.deliveryMethod.turbo.price.toString();
      _deliveryTimes["Turbo"]!.text = attr.deliveryMethod.turbo.deliveryTime;

      _deliveryEnabled["Standard"] = attr.deliveryMethod.standard.enabled;
      _deliveryPrices["Standard"]!.text = attr.deliveryMethod.standard.price.toString();
      _deliveryTimes["Standard"]!.text = attr.deliveryMethod.standard.deliveryTime;

      _deliveryEnabled["Basic"] = attr.deliveryMethod.basic.enabled;
      _deliveryPrices["Basic"]!.text = attr.deliveryMethod.basic.price.toString();
      _deliveryTimes["Basic"]!.text = attr.deliveryMethod.basic.deliveryTime;

      _deliveryEnabled["Pickup"] = attr.deliveryMethod.pickup.enabled;
      _deliveryPrices["Pickup"]!.text = attr.deliveryMethod.pickup.price.toString();

      _costsEnabled["Vendor"] = attr.costsAndFees.handledByVendor.enabled;
      _costsEnabled["Customer"] = attr.costsAndFees.handledByCustomer.enabled;
      _costsEnabled["Free"] = attr.costsAndFees.conditionalFreeShipping.enabled;
      _freeShippingMinAmount.text = attr.costsAndFees.conditionalFreeShipping.minOrderAmount.toString();
    });
  }

  void _handleSave() {
    final postBody = OrderFullFillmentPostBody(
      shippingMethod: ShippingMethodConfig(
        turbo: MethodOption(enabled: _shippingEnabled["Turbo"], deliveryTime: _shippingTimes["Turbo"]!.text, price: double.tryParse(_shippingPrices["Turbo"]!.text)),
        standard: MethodOption(enabled: _shippingEnabled["Standard"], deliveryTime: _shippingTimes["Standard"]!.text, price: double.tryParse(_shippingPrices["Standard"]!.text)),
        basic: MethodOption(enabled: _shippingEnabled["Basic"], deliveryTime: _shippingTimes["Basic"]!.text, price: double.tryParse(_shippingPrices["Basic"]!.text)),
      ),
      deliveryMethod: DeliveryMethodConfig(
        turbo: MethodOption(enabled: _deliveryEnabled["Turbo"], deliveryTime: _deliveryTimes["Turbo"]!.text, price: double.tryParse(_deliveryPrices["Turbo"]!.text)),
        standard: MethodOption(enabled: _deliveryEnabled["Standard"], deliveryTime: _deliveryTimes["Standard"]!.text, price: double.tryParse(_deliveryPrices["Standard"]!.text)),
        basic: MethodOption(enabled: _deliveryEnabled["Basic"], deliveryTime: _deliveryTimes["Basic"]!.text, price: double.tryParse(_deliveryPrices["Basic"]!.text)),
        pickup: PickupOption(enabled: _deliveryEnabled["Pickup"], price: double.tryParse(_deliveryPrices["Pickup"]!.text)),
      ),
      costsAndFees: CostsAndFeesConfig(
        handledByVendor: FeeOption(enabled: _costsEnabled["Vendor"], amount: 0),
        handledByCustomer: FeeOption(enabled: _costsEnabled["Customer"], amount: 0),
        conditionalFreeShipping: ConditionalFreeShipping(enabled: _costsEnabled["Free"], minOrderAmount: double.tryParse(_freeShippingMinAmount.text)),
      ),
    );
    controller.updateSettings(postBody);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Order Fulfillment", showBackButton: true),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _buildHeader("Shipping Method", subtitle: "(for international orders)"),
            _buildOption("Turbo", "Turbo", _shippingEnabled, _shippingPrices, _shippingTimes),
            _buildOption("Standard", "Standard", _shippingEnabled, _shippingPrices, _shippingTimes),
            _buildOption("Basic", "Basic", _shippingEnabled, _shippingPrices, _shippingTimes),

            SizedBox(height: 30.h),
            _buildHeader("Delivery Method", subtitle: "(for local orders)"),
            _buildOption("Turbo", "Turbo", _deliveryEnabled, _deliveryPrices, _deliveryTimes),
            _buildOption("Standard", "Standard", _deliveryEnabled, _deliveryPrices, _deliveryTimes),
            _buildOption("Basic", "Basic", _deliveryEnabled, _deliveryPrices, _deliveryTimes),
            _buildOption("Pickup", "Pickup", _deliveryEnabled, _deliveryPrices, null),

            SizedBox(height: 30.h),
            _buildHeader("Costs & Fees", subtitle: "(time needed before shipping)"),
            _buildSimpleToggle("Duties & Taxes Handled By Vendor", "Vendor", _costsEnabled),
            _buildSimpleToggle("Duties & Taxes Handled By Customer", "Customer", _costsEnabled),
            _buildOption("Conditional Free Shipping", "Free", _costsEnabled, {"Free": _freeShippingMinAmount}, null, extraLabel: "For orders over:"),

            SizedBox(height: 50.h),
            _buildSaveButton(),
            SizedBox(height: 40.h),
          ],
        ),
      )),
    );
  }

  Widget _buildOption(String label, String key, Map<String, bool> enabledMap, Map<String, TextEditingController> priceMap, Map<String, TextEditingController>? timeMap, {String? extraLabel}) {
    bool isSelected = enabledMap[key] ?? false;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.geryColor.withValues(alpha:0.1)))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (extraLabel != null) CustomText(text: extraLabel, fontSize: 10.sp, color: AppColors.geryColor, bottom: 2.h),
                Row(
                  children: [
                    CustomText(text: label, fontSize: 12.sp, color: AppColors.primaryDark, fontWeight: FontWeight.w500),
                    if (timeMap != null) ...[
                      CustomText(text: " (", fontSize: 12.sp, color: AppColors.primaryDark, fontWeight: FontWeight.w500),
                      IntrinsicWidth(
                        child: TextField(
                          controller: timeMap[key],
                          enabled: isSelected,
                          onChanged: (value) => setState(() {}), // Refresh to update IntrinsicWidth
                          style: TextStyle(fontSize: 12.sp, color: AppColors.primaryDark, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      CustomText(text: ")", fontSize: 12.sp, color: AppColors.primaryDark, fontWeight: FontWeight.w500),
                    ]
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => enabledMap[key] = !isSelected),
            icon: Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank, color: isSelected ? const Color(0xFF4A5D3F) : AppColors.geryColor.withValues(alpha:0.3)),
          ),
          SizedBox(width: 15.w),
          Container(
            width: 80.w,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(color: const Color(0xFFEBEBEB), borderRadius: BorderRadius.circular(8.r)),
            child: TextField(
              controller: priceMap[key],
              enabled: isSelected,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColors.geryColor),
              decoration: const InputDecoration(prefixText: "\$ ", border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleToggle(String label, String key, Map<String, bool> enabledMap) {
    bool isSelected = enabledMap[key] ?? false;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomText(text: label, fontSize: 12.sp, color: AppColors.primaryDark),
      trailing: Icon(isSelected ? Icons.check_box : Icons.check_box_outline_blank, color: isSelected ? const Color(0xFF4A5D3F) : AppColors.geryColor.withValues(alpha:0.3)),
      onTap: () => setState(() => enabledMap[key] = !isSelected),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: controller.isSaving.value ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E3020),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        ),
        child: controller.isSaving.value
            ? const CircularProgressIndicator(color: Colors.white)
            : CustomText(text: "Save", color: AppColors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildHeader(String title, {required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomText(text: title, fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
            SizedBox(width: 5.w),
            CustomText(text: subtitle, fontSize: 10.sp, color: AppColors.geryColor),
          ],
        ),
        SizedBox(height: 4.h),
        CustomText(text: "Select all that apply", fontSize: 11.sp, color: AppColors.geryColor.withValues(alpha:0.6)),
        CustomText(text: "** You Can Change Business Day & Price **", fontSize: 11.sp, color: AppColors.error),

        SizedBox(height: 10.h),
      ],
    );
  }
}