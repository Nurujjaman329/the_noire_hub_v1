import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text.dart';


class ServiceDetailsScreen extends StatelessWidget {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: CustomAppBar(title: "Details",showBackButton: true,),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image Carousel Section
            _buildImageCarousel(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  // 2. Title and Price
                  CustomText(
                    text: "Skie Jojoba Castor Hair Growth Oil",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 10.h),
                  CustomText(
                    text: "\$1500.00",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1D3826),
                  ),

                  const Divider(height: 40, thickness: 1),

                  // 3. Description Section
                  _buildSectionTitle("Description"),
                  CustomText(
                    text: "Moisture Retainment, Hair Growth Stimulation, All natural ingredients, NDA Approved, Petroleum free",
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                  ),

                  SizedBox(height: 25.h),

                  _buildSectionTitle("Size", subtitle: "how thick would you prefer?"),
                  _buildOptionGrid([
                    {"label": "Micro", "price": "\$100"},
                    {"label": "Mini", "price": "\$80"},
                    {"label": "Small", "price": "\$100"},
                  ]),


                  SizedBox(height: 25.h),

                  // 5. Grid Selection (Service Style - Size/Length)
                  _buildSectionTitle("Length", subtitle: "how long would you prefer?"),
                  _buildOptionGrid([
                    {"label": "Micro", "price": "\$100"},
                    {"label": "Mini", "price": "\$80"},
                    {"label": "Small", "price": "\$100"},
                  ]),

                  SizedBox(height: 25.h),

                  CustomText(text: "Services Date & Time",color: Color(0XFF1D3826),fontSize: 27.sp,),
                  SizedBox(height: 10.h),

                  CustomText(text: "31 January 2026  10:30 AM",color: Color(0XFF1D3826),fontSize: 18.sp,),


                  SizedBox(height: 25.h),
                  // 6. Location Selection
                  _buildSectionTitle("Location", subtitle: "where would you prefer to meet?"),
                  _buildLocationSelector(),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildImageCarousel() {
    return Column(
      children: [
        Container(
          height: 300.h,
          width: double.infinity,
          margin: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            image: const DecorationImage(
              image: NetworkImage("https://images.pexels.com/photos/3616991/pexels-photo-3616991.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 6.h,
            width: index == 0 ? 12.w : 6.w,
            decoration: BoxDecoration(
              color: index == 0 ? const Color(0xFF1D3826) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {String? subtitle}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: title, fontSize: 18.sp, fontWeight: FontWeight.bold),
          if (subtitle != null)
            CustomText(text: subtitle, fontSize: 11.sp, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildVariantTile(String size, String price) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F4),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF9BB575).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: size, fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black87),
          CustomText(text: price, fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.black87),
        ],
      ),
    );
  }

  Widget _buildOptionGrid(List<Map<String, String>> options) {
    return Row(
      children: options.map((opt) => Expanded(
        child: Container(
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F0B2).withOpacity(0.5),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF1D3826),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Center(child: CustomText(text: opt['label']!, color: Colors.white, fontSize: 12.sp)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomText(text: opt['price']!, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildLocationSelector() {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xFF1D3826).withOpacity(0.3)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  CustomText(text: "Home Service", fontWeight: FontWeight.bold),
                  CustomText(text: "+\$20", color: Colors.grey, fontSize: 12.sp),
                ],
              ),
            ),
            const VerticalDivider(thickness: 2, color: Color(0xFF1D3826)),
            Expanded(
              child: Column(
                children: [
                  CustomText(text: "Salon", fontWeight: FontWeight.bold),
                  CustomText(text: "\$0.00", color: Colors.grey, fontSize: 12.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}