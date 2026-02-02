

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text.dart';

class VendorProductDetailsScreen extends StatelessWidget {
  const VendorProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Image Header with Back Button
          SliverAppBar(
            expandedHeight: 380.h,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            // Disable the default leading/title so they don't overlap with your CustomAppBar
            automaticallyImplyLeading: false,

            // 2. This is where your CustomAppBar lives when pinned
            title: CustomAppBar(
              title: "Details",
              showBackButton: true,
              bgColor: Colors.transparent, // Transparent so it blends
              arrowColor: const Color(0xFF1D3826),
            ),
            centerTitle: true,

            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  SizedBox(height: 100.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.r),
                    child: Image.network(
                      "https://images.pexels.com/photos/3616991/pexels-photo-3616991.jpeg",
                      height: 300.h,
                      width: 340.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(isActive: true),
                      _buildDot(isActive: false),
                      _buildDot(isActive: false),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. Product Information
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Skie Jojoba Castor Hair Growth Oil",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1D3826),
                  ),
                  SizedBox(height: 10.h),
                  CustomText(
                    text: "\$1500.00",
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1D3826),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: Divider(color: Colors.grey.shade300, thickness: 1),
                  ),

                  CustomText(
                    text: "Description",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    text: "Moisture Retainment, Hair Growth Stimulation, All natural ingredients, NDA Approved, Petroleum free",
                    fontSize: 14.sp,
                    color: Colors.black54,
                    height: 1.4,
                  ),

                  SizedBox(height: 25.h),


                  // 3. Variant List
                  _buildVariantSection(),
                  // _buildVariantTile("200 ml", "\$200"),
                  // _buildVariantTile("100 ml", "\$100"),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      height: 6.r,
      width: 6.r,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1D3826) : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildVariantSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "Available Variants",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1D3826),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F4),
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: const Color(0xFF9BB575).withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header Row with slightly darker background
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D3826).withOpacity(0.03),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    topRight: Radius.circular(15.r),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomText(
                            text: "Unit/Size",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600
                        )
                    ),
                    CustomText(
                        text: "Price",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600
                    ),
                    SizedBox(width: 35.w), // Space for the action icon
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),

              // Variant Rows
              _buildTableRow("500 ml", "\$500.00"),
              _buildTableRow("200 ml", "\$200.00"),
              _buildTableRow("100 ml", "\$100.00", isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(String label, String price, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
          child: Row(
            children: [
              Expanded(
                child: CustomText(
                  text: label,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D3826),
                ),
              ),
              CustomText(
                text: price,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1D3826),
              ),
              SizedBox(width: 10.w),
              // Vendor Action Button

            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Divider(color: Colors.grey.withOpacity(0.1), height: 1),
          ),
      ],
    );
  }


}