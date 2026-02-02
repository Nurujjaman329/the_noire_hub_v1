import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/navigationController/app_navigation_controller.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';


class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isExpanded = false;

  // New State Variables for Variants
  String selectedSize = "M"; // Default selection
  String selectedColor = "Green";
  double currentPrice = 0.00;

  // Example Data Structure - In a real app, this comes from your backend
  final List<String> availableSizes = ["S", "M", "L", "XL"];
  final List<Map<String, dynamic>> colorVariants = [
    {"name": "Green", "color": Color(0xFF000000), "price": 25.00},
    {"name": "Blue", "color": Colors.blueGrey, "price": 28.00},
    {"name": "Cream", "color": Color(0xFFF5F5DC), "price": 22.00},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize price from the default variant or passed arguments
    currentPrice = 25.00;
  }

  @override
  Widget build(BuildContext context) {

    final Map<String, dynamic> data = Get.arguments ?? {
      'title': "Product Detail",
      'price': "0.00",
      'image': "",
    };

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Product Details",
        showBackButton: true,

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: GestureDetector(
              onTap: () {
                // 1. Find the navigation controller
                final navCtrl = Get.find<AppNavigationController>();

                // 2. Update the index BEFORE navigating
                navCtrl.changeCustomerIndex(3);

                // 3. Navigate to the main container
                // Using offAllNamed ensures we clear the product detail from the stack
                Get.offAllNamed(RouteConstants.customerMainContainer);
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.textPrimary,
                      size: 24.sp,
                    ),
                  ),
                  Positioned(
                    right: 4.w,
                    top: 4.h,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryVariant,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16.w,
                        minHeight: 16.w,
                      ),
                      child: Center(
                        child: CustomText(
                          text: "1",
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        color: AppColors.white,
        child: _buildFloatingAddToCart(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Image Section with Indicators
            Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: data['image'],
                  height: 350.h,
                  width: double.infinity,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
                Positioned(
                  bottom: 15.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) => _buildDotIndicator(index == 0)),
                  ),
                )
              ],
            ),

            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                          text: "Skie Homemade Care Products | 2-10 Days Delivery",
                          fontSize: 10.sp,
                          color: AppColors.geryColor
                      ),
                      GestureDetector(
                          onTap: () {},
                          child: CustomText(
                              text: "View Store",
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF3F592B)
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CustomText(text: data['title'], fontSize: 24.sp, fontWeight: FontWeight.bold, textAlign: TextAlign.start),
                  SizedBox(height: 15.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "\$${currentPrice.toStringAsFixed(2)}",
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                      _buildRatingBadge(),
                    ],
                  ),

                  SizedBox(height: 25.h),

                  // --- SIZE SELECTION ---
                  CustomText(text: "Select Size", fontSize: 14.sp, fontWeight: FontWeight.bold),
                  SizedBox(height: 12.h),
                  Row(
                    children: availableSizes.map((size) => _buildSizeOption(size)).toList(),
                  ),

                  SizedBox(height: 25.h),

                  // --- COLOR SELECTION ---
                  CustomText(text: "Color: $selectedColor", fontSize: 14.sp, fontWeight: FontWeight.bold),
                  SizedBox(height: 12.h),
                  Row(
                    children: colorVariants.map((variant) => _buildColorOption(variant)).toList(),
                  ),

                  // Row(
                  //   children: [
                  //     _buildVariationImage(data['image'], true),
                  //     _buildVariationImage("https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?q=80&w=200", false),
                  //     _buildVariationImage("https://images.unsplash.com/photo-1590159346183-406b75bc912d?q=80&w=200", false),
                  //   ],
                  // ),

                  SizedBox(height: 25.h),
                  CustomText(text: "Description", fontSize: 14.sp, fontWeight: FontWeight.bold),
                  SizedBox(height: 10.h),
                  CustomText(
                    text: "Moisture Retainment, Hair Growth Stimulation, All natural ingredients, NDA Approved, Petroleum free. This product is formulated by Skie Homemade Care.",
                    fontSize: 12.sp,
                    color: AppColors.textPrimary,
                    textAlign: TextAlign.start,
                  ),

                  SizedBox(height: 20.h),


                  if (isExpanded) ...[
                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15.r),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: CustomText(
                        text: "• 100% Organic Ingredients\n• No Artificial Fragrances\n• Cruelty-Free and Vegan",
                        fontSize: 12.sp,
                        textAlign: TextAlign.start,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],

                  SizedBox(height: 30.h),
                  CustomText(text: "Similar Products From Skie", fontSize: 14.sp, fontWeight: FontWeight.bold),
                  SizedBox(height: 15.h),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildProductCard("Naturals Argan Shampoo", "13.00", "https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?q=80&w=200"),
                        _buildProductCard("Skie Coconut & Peach Pomade", "15.00", "https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?q=80&w=200"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildFloatingAddToCart() {
    return GestureDetector(
      onTap: () {
        // 1. Find the navigation controller
        final navCtrl = Get.find<AppNavigationController>();

        // 2. Update the index BEFORE navigating
        navCtrl.changeCustomerIndex(3);

        // 3. Navigate to the main container
        // Using offAllNamed ensures we clear the product detail from the stack
        Get.offAllNamed(RouteConstants.customerMainContainer);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0XFF1D3826),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.remove, color: AppColors.white),
                onPressed: () {
                  if (quantity > 1) setState(() => quantity--);
                }
            ),
            CustomText(
                text: "Add To Cart | $quantity",
                color: AppColors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold
            ),
            IconButton(
                icon: const Icon(Icons.add, color: AppColors.white),
                onPressed: () => setState(() => quantity++)
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildDotIndicator(bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      height: 6.h,
      width: 6.w,
      decoration: BoxDecoration(
        color: isActive ? AppColors.textPrimary : AppColors.dividerVariant,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20.r)
      ),
      child: Row(
        children: [
          Icon(Icons.star, size: 14.sp, color: AppColors.textPrimary),
          SizedBox(width: 4.w),
          CustomText(text: "4.8 | 100+", fontSize: 12.sp, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildVariationImage(String url, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
            color: isSelected ? AppColors.primaryDark : Colors.transparent,
            width: 2
        ),
      ),
      child: CustomNetworkImage(
          imageUrl: url,
          height: 80.h,
          width: 80.w,
          borderRadius: BorderRadius.circular(13.r)
      ),
    );
  }


  Widget _buildProductCard(String title, String price, String imgUrl) {
    return Container(
      width: 140.w,
      margin: EdgeInsets.only(right: 15.w),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(25.r)
      ),
      child: Column(
        children: [
          CustomNetworkImage(
              imageUrl: imgUrl,
              height: 90.h,
              width: 100.w,
              borderRadius: BorderRadius.circular(15.r)
          ),
          SizedBox(height: 10.h),
          CustomText(text: title, fontSize: 10.sp, fontWeight: FontWeight.bold, maxLines: 2),
          SizedBox(height: 5.h),
          Row(
            children: [
              CustomText(text: "\$$price", fontSize: 12.sp, fontWeight: FontWeight.bold),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
                    shape: BoxShape.circle
                ),
                child: Icon(Icons.arrow_forward_ios, color: AppColors.white, size: 8.sp),
              )
            ],
          )
        ],
      ),
    );
  }


  Widget _buildSizeOption(String size) {
    bool isSelected = selectedSize == size;
    return GestureDetector(
      onTap: () => setState(() => selectedSize = size),
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isSelected ? AppColors.primaryDark : AppColors.geryColor.withOpacity(0.3)),
        ),
        child: CustomText(
          text: size,
          color: isSelected ? AppColors.white : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildColorOption(Map<String, dynamic> variant) {
    bool isSelected = selectedColor == variant['name'];
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = variant['name'];
          currentPrice = variant['price']; // Vendor logic: change price based on color
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 15.w),
        padding: EdgeInsets.all(3.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : Colors.transparent,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          radius: 18.r,
          backgroundColor: variant['color'],
        ),
      ),
    );
  }
}