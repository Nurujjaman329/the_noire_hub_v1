import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';



class OrderFulfillmentScreen extends StatefulWidget {
  const OrderFulfillmentScreen({super.key});

  @override
  State<OrderFulfillmentScreen> createState() => _OrderFulfillmentScreenState();
}

class _OrderFulfillmentScreenState extends State<OrderFulfillmentScreen> {
  // Sets to store selected items
  final Set<String> _selectedShipping = {"Standard (2 - 5 business days)"};
  final Set<String> _selectedDelivery = {"Standard (2 - 5 business days)", "Pickup"};
  final Set<String> _selectedCosts = {"Duties & Taxes Handled By Customer"};

  void _toggleSelection(Set<String> selectionSet, String label) {
    setState(() {
      if (selectionSet.contains(label)) {
        selectionSet.remove(label);
      } else {
        selectionSet.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Order Fulfillment", showBackButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            // 1. Shipping Method Section
            _buildHeader("Shipping Method", subtitle: "(for international orders)"),
            _buildFulfillmentOption("Turbo (1 - 2 business days)", _selectedShipping),
            _buildFulfillmentOption("Standard (2 - 5 business days)", _selectedShipping),
            _buildFulfillmentOption("Basic (5 - 10 business days)", _selectedShipping),

            SizedBox(height: 30.h),

            // 2. Delivery Method Section
            _buildHeader("Delivery Method", subtitle: "(for local orders)"),
            _buildFulfillmentOption("Turbo (1 - 2 business days)", _selectedDelivery),
            _buildFulfillmentOption("Standard (2 - 5 business days)", _selectedDelivery),
            _buildFulfillmentOption("Basic (5 - 10 business days)", _selectedDelivery),
            _buildFulfillmentOption("Pickup", _selectedDelivery),

            SizedBox(height: 30.h),

            // 3. Costs & Fees Section
            _buildHeader("Costs & Fees", subtitle: "(time needed before shipping)"),
            _buildFulfillmentOption("Duties & Taxes Handled By Vendor", _selectedCosts),
            _buildFulfillmentOption("Duties & Taxes Handled By Customer", _selectedCosts),
            _buildFulfillmentOption("Conditional Free Shipping", _selectedCosts, extraLabel: "For orders over:"),

            SizedBox(height: 50.h),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3020),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                  elevation: 0,
                ),
                child: CustomText(
                  text: "Save",
                  color: AppColors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
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
        CustomText(text: "Select all that apply", fontSize: 11.sp, color: AppColors.geryColor.withOpacity(0.6)),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildFulfillmentOption(String label, Set<String> selectionSet, {String? extraLabel}) {
    bool isSelected = selectionSet.contains(label);

    return GestureDetector(
      onTap: () => _toggleSelection(selectionSet, label),
      behavior: HitTestBehavior.opaque, // Makes the whole row clickable
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.geryColor.withOpacity(0.1))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (extraLabel != null)
                    CustomText(text: extraLabel, fontSize: 10.sp, color: AppColors.geryColor, bottom: 2.h),
                  CustomText(text: label, fontSize: 12.sp, color: AppColors.primaryDark, fontWeight: FontWeight.w500),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? const Color(0xFF4A5D3F) : AppColors.geryColor.withOpacity(0.3),
              size: 24.sp,
            ),
            SizedBox(width: 15.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFEBEBEB),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: CustomText(
                text: "\$ 0.00",
                fontSize: 12.sp,
                color: AppColors.geryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}