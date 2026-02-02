import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_text.dart';

class CustomerBookingSuccess extends StatelessWidget {
  const CustomerBookingSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCADA9F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: CustomText(
          text: "Thanks For Booking!",
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2D3E2F),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 30.h),

                    // 1. Success Status Header
                    CustomText(text: "Payment Success", fontSize: 24.sp, fontWeight: FontWeight.bold),
                    SizedBox(height: 15.h),
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(0xFF2D3E2F),
                      child: Icon(Icons.check, color: Colors.white, size: 35),
                    ),

                    const Divider(height: 50, thickness: 1, color: Color(0xFFF1F4D3)),

                    // 2. Appointment Details
                    _buildDetailSection(),

                    const Divider(height: 50, thickness: 1, color: Color(0xFFF1F4D3)),

                    // 3. Action Icons (Reminder, Save, Gift)
                    _buildActionIcons(),

                    const Divider(height: 50, thickness: 2, color: Color(0xFFC4C99A)),

                    // 4. Recommendations Section
                    _buildRecommendations(),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "Appointment Details", fontSize: 18.sp, fontWeight: FontWeight.bold),
          SizedBox(height: 25.h),
          _detailRow("Service Provider", "Braids By Mia"),
          _detailRow("Services", "Knotless Braids\nMedium Size\nArmpit Length"),
          _detailRow("Location", "Salon\n12 Island Crescent NW,\nBanff, AB, T1L1A4"),
          _detailRow("Date", "October 3rd 2025"),
          _detailRow("Time", "1:00 AM (MST)"),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(text: label, fontSize: 14.sp, color: Colors.black87),
          Expanded(
            child: CustomText(
                text: value,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.right,
              color: Color(0XFF000000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _iconButton(Icons.alarm, "Reminder"),
        _iconButton(Icons.download_outlined, "Save"),
        _iconButton(Icons.card_giftcard, "Send Gift"),
      ],
    );
  }

  Widget _iconButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F0B2),
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Icon(icon, size: 30, color: const Color(0xFF2D3E2F)),
        ),
        SizedBox(height: 8.h),
        CustomText(text: label, fontSize: 11.sp, fontWeight: FontWeight.w500),
      ],
    );
  }

  Widget _buildRecommendations() {
    final List<Map<String, String>> products = [
      {"name": "Naturals Argan Shampoo", "price": "\$13.00", "img": "https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=200"},
      {"name": "Skie Coconut & Peach Pomade", "price": "\$15.00", "img": "https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?q=80&w=200"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: CustomText(text: "Products You Might Need", fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 25.w),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Container(
                width: 160.w,
                margin: EdgeInsets.only(right: 15.w),
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F0B2),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: Image.network(products[index]['img']!, height: 100.h, width: double.infinity, fit: BoxFit.cover),
                    ),
                    const Spacer(),
                    CustomText(text: products[index]['name']!, fontSize: 12.sp, fontWeight: FontWeight.bold, textAlign: TextAlign.center),
                    CustomText(text: products[index]['price']!, fontSize: 11.sp, color: Colors.black54),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(radius: 12, backgroundColor: Color(0xFF2D3E2F), child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10)),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}