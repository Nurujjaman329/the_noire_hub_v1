import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/app_snackbar.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';

import 'package:intl/intl.dart';

import '../controller/customer_deals_promos_controller.dart';

class CustomerDealsPromosScreen extends StatefulWidget {
  const CustomerDealsPromosScreen({super.key});

  @override
  State<CustomerDealsPromosScreen> createState() =>
      _CustomerDealsPromosScreenState();
}

class _CustomerDealsPromosScreenState extends State<CustomerDealsPromosScreen> {
  static String vendorStoreTop = AppAssets.registration;
  late final CustomerDealsPromosController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CustomerDealsPromosController>();
    controller.fetchPromos(clearFilters: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: RefreshIndicator(
        onRefresh: () => controller.fetchPromos(clearFilters: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  CustomNetworkImage(
                    imageUrl: vendorStoreTop,
                    height: 250.h,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: 40.h,
                    left: 20.w,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Available Promos & Deals",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: 6.h),
                    CustomText(
                      text: "Copy a code and use it at checkout or booking.",
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                    SizedBox(height: 15.h),
                    Obx(() {
                      if (controller.isListLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.promoList.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: CustomText(
                              text: "No promos available",
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return _buildWhiteCard(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.promoList.length,
                          separatorBuilder: (context, index) =>
                              const Divider(color: AppColors.divider),
                          itemBuilder: (context, index) {
                            final promo = controller.promoList[index];

                            String formattedExpiry = "N/A";
                            if (promo.expiryDate.isNotEmpty) {
                              try {
                                final dateTime =
                                    DateTime.parse(promo.expiryDate);
                                formattedExpiry =
                                    DateFormat('MM/dd/yyyy').format(dateTime);
                              } catch (_) {
                                formattedExpiry = promo.expiryDate;
                              }
                            }

                            final seller = promo.createdBy?.businessName
                                    .trim()
                                    .isNotEmpty ==
                                true
                                ? promo.createdBy!.businessName
                                : (promo.createdBy?.fullName ?? 'Seller');
                            final typeLabel = _typeLabel(promo.applicableFor);

                            return _promoTile(
                              title:
                                  "${promo.discountPercentage}% OFF · ${promo.code}",
                              subtitle:
                                  "$seller · $typeLabel\nMin \$${promo.minPurchaseAmount} · Exp $formattedExpiry",
                              code: promo.code,
                            );
                          },
                        ),
                      );
                    }),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _typeLabel(String applicableFor) {
    switch (applicableFor.toLowerCase()) {
      case 'product':
        return 'Products';
      case 'service':
        return 'Services';
      case 'both':
        return 'Products & Services';
      default:
        return applicableFor.isEmpty ? 'Offer' : applicableFor;
    }
  }

  Widget _buildWhiteCard({required Widget child, EdgeInsetsGeometry? margin}) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: child,
    );
  }

  Widget _promoTile({
    required String title,
    required String subtitle,
    required String code,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: subtitle,
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: code));
              AppSnackbar.success(
                'Code $code copied. Use it at checkout or booking.',
                title: 'Copied',
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF9BB575),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: CustomText(
                text: "Copy",
                fontSize: 11.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
