import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../../core/widgets/custom_text.dart';

class ServicePopularNearYouScreen extends StatelessWidget {
  const ServicePopularNearYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data based on your images
    final List<Map<String, String>> popularList = [
      {"name": "Braids By Mia", "style": "Knotless Braids", "price": "150", "dist": "7 km away", "rate": "4.8", "img": "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=500"},
      {"name": "Braids By Mia", "style": "Knotless Braids", "price": "150", "dist": "7 km away", "rate": "4.8", "img": "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=500"},
      {"name": "Hair Artistry", "style": "Box Braids", "price": "90", "dist": "3 km away", "rate": "4.9", "img": "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=500"},
      {"name": "Braids By Mia", "style": "Cornrows", "price": "150", "dist": "7 km away", "rate": "4.8", "img": "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=500"},
      {"name": "Style Studio", "style": "Twists", "price": "70", "dist": "5 km away", "rate": "4.7", "img": "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=500"},
      {"name": "Loc'd Up", "style": "Faux Locs", "price": "120", "dist": "6 km away", "rate": "4.6", "img": "https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=500"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Popular Near You",showBackButton: true,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15.w,
            mainAxisSpacing: 15.h,
            mainAxisExtent: 260.h, // Adjusted height for vertical card
          ),
          itemCount: popularList.length,
          itemBuilder: (context, index) {
            final item = popularList[index];
            return _popularVerticalCard(
              item['name']!,
              item['style']!,
              item['price']!,
              item['dist']!,
              item['rate']!,
              item['img']!,
            );
          },
        ),
      ),
    );
  }

  Widget _popularVerticalCard(
      String name,
      String style,
      String price,
      String distance,
      String rating,
      String imageUrl,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F0B2), // Matches your card background color
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section with Favorite Icon
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
                  child: CustomNetworkImage(
                    imageUrl: imageUrl,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: CircleAvatar(
                    radius: 15.r,
                    backgroundColor: const Color(0xFF1D3826).withValues(alpha:0.8),
                    child: Icon(Icons.favorite, color: const Color(0xFFF1F0B2), size: 16.sp),
                  ),
                ),
              ],
            ),
          ),
          // Info Section
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: name,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomText(
                      text: style,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: distance, fontSize: 10.sp, color: Colors.black54),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            CustomText(text: "$rating ", fontSize: 10.sp, color: const Color(0xFF9BB575)),
                            Icon(Icons.star, size: 10.sp, color: const Color(0xFF9BB575)),
                            CustomText(text: " (25)", fontSize: 10.sp, color: Colors.black54),
                          ],
                        ),
                      ],
                    ),
                    CustomText(
                      text: "\$$price",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}