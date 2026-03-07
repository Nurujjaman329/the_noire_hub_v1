import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/cache_service.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../data/model/add_deals_promos_post_body.dart';
import '../../data/model/deals_promos_response_model.dart';
import '../controller/add_deals_promos_controller.dart';
import 'package:intl/intl.dart';


class AddDealsPomosScreen extends StatelessWidget {
  const AddDealsPomosScreen({super.key});

  static String vendorStoreTop = AppAssets.registration;

  @override
  Widget build(BuildContext context) {
    final promoController = Get.find<PromoCodeController>();

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Top Image Header
            Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: vendorStoreTop,
                  height: 250.h,
                  width: double.infinity,
                ),
                Positioned(
                  top: 40.h, left: 20.w,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                      child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
                    ),
                  ),
                ),
              ],
            ),

            // 2. Add Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 8.h),
              child: CustomButton(
                onTap: () => showPromoSheet(context, isEdit: false),
                text: "Add Promo Code",
              ),
            ),

            // 3. Dynamic Promo List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Available Promos & Deals",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  SizedBox(height: 15.h),

                  Obx(() {
                    if (promoController.isListLoading.value) {
                      return const Center(child: CircularProgressIndicator(color: Color(0XFF1D3826)));
                    }

                    if (promoController.promoList.isEmpty) {
                      return _buildWhiteCard(
                        child: const Center(child: CustomText(text: "No active promos found.")),
                      );
                    }

                    return _buildWhiteCard(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: promoController.promoList.length,
                        itemBuilder: (context, index) {
                          final promo = promoController.promoList[index];
                          return _promoTile(
                            context,
                            promoData: promo,
                            isLast: index == promoController.promoList.length - 1,
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
    );
  }

  // --- List Tile Card ---

  Widget _promoTile(BuildContext context, {required PromoCodeModel promoData, bool isLast = false}) {
    final promoController = Get.find<PromoCodeController>();

    String formattedDate = "";
    try {
      DateTime dateTime = DateTime.parse(promoData.expiryDate);
      formattedDate = DateFormat('dd MMM, yyyy').format(dateTime);
    } catch (e) {
      formattedDate = promoData.expiryDate; // Fallback to raw string if parsing fails
    }

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: CustomText(
            text: promoData.code,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0XFF1D3826),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                // ✅ Removed "Till", added "Expiry Date:", and used formattedDate
                text: promoData.title,
                fontSize: 12.sp,
                color: Colors.grey,
              ),
              CustomText(
                text: "Stock: ${promoData.maxUsageCount}",
                fontSize: 12.sp,
                color: Colors.grey,
              ),
              CustomText(
                text: "Expiry Date: $formattedDate",
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ],
          ),
          trailing: SizedBox(
            width: 85.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Edit Button
                GestureDetector(
                  onTap: () => showPromoSheet(context, isEdit: true, id: promoData.id, promoData: promoData),
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: const Color(0XFFF1F0B2),
                    child: Icon(Icons.edit, color: const Color(0XFF1D3826), size: 16.sp),
                  ),
                ),
                SizedBox(width: 8.w),
                // Delete Button
                GestureDetector(
                  onTap: () {
                    Get.defaultDialog(
                      title: "Delete Promo",
                      middleText: "Are you sure you want to remove ${promoData.code}?",
                      textConfirm: "Delete",
                      textCancel: "Cancel",
                      confirmTextColor: Colors.white,
                      buttonColor: Colors.redAccent,
                      onConfirm: () {
                        promoController.removePromo(promoData.id);
                        Get.back();
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: const Color(0XFFF1F0B2),
                    child: Icon(Icons.delete, color: const Color(0XFF1D3826), size: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(color: AppColors.divider),
      ],
    );
  }
  // --- Bottom Sheet ---
  void showPromoSheet(BuildContext context, {bool isEdit = false, String? id, PromoCodeModel? promoData}) {
    final promoController = Get.find<PromoCodeController>();

    final TextEditingController titleController = TextEditingController(text: isEdit ? promoData?.title : "");
    final TextEditingController codeController = TextEditingController(text: isEdit ? promoData?.code : "");
    final TextEditingController percentController = TextEditingController(text: isEdit ? promoData?.discountPercentage.toString() : "");
    final TextEditingController dateController = TextEditingController(text: isEdit ? promoData?.expiryDate : "");
    final TextEditingController usageController = TextEditingController(text: isEdit ? promoData?.maxUsageCount.toString() : "");
    final TextEditingController descController = TextEditingController(text: isEdit ? promoData?.description : "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF9F9F4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(25.w),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: CustomText(text: isEdit ? "Edit Promo" : "Create Promo", fontSize: 24.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 25.h),

                      if (!isEdit) ...[
                        _buildSheetLabel("Promo Code (Unique)"),
                        _buildSheetInputField(hint: "SUMMER50", controller: codeController),
                        SizedBox(height: 15.h),
                      ],

                      _buildSheetLabel("Promo Title"),
                      _buildSheetInputField(hint: "Flash Sale", controller: titleController),

                      SizedBox(height: 15.h),
                      if (!isEdit)  Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSheetLabel("Discount %"),
                                _buildSheetInputField(hint: "10", controller: percentController, keyboardType: TextInputType.number),
                              ],
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSheetLabel("Max Usage"),
                                _buildSheetInputField(hint: "100", controller: usageController, keyboardType: TextInputType.number),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),
                      _buildSheetLabel("Expiry Date"),
                      GestureDetector(
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setModalState(() => dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}");
                          }
                        },
                        child: AbsorbPointer(
                          child: _buildSheetInputField(hint: "YYYY-MM-DD", controller: dateController, suffixIcon: const Icon(Icons.calendar_month)),
                        ),
                      ),

                      SizedBox(height: 15.h),
                      _buildSheetLabel("Description"),
                      _buildSheetInputField(hint: "Details about the offer...", isLarge: true, controller: descController),

                      SizedBox(height: 30.h),
                      Obx(() => CustomButton(
                        text: promoController.isLoading.value ? "Processing..." : (isEdit ? "Update" : "Create Offer"),
                        onTap: promoController.isLoading.value ? null : () {
                          if (isEdit) {
                            promoController.patchPromo(id!, EditDealsPromosPostBody(
                              title: titleController.text,
                              expiryDate: dateController.text,
                              description: descController.text,
                            ));
                          } else {
                            promoController.addPromo(
                              AddDealsPromosPostBody(
                                code: codeController.text,
                                title: titleController.text,
                                discountPercentage: int.tryParse(percentController.text) ?? 0,
                                description: descController.text,
                                expiryDate: dateController.text,
                                maxUsageCount: int.tryParse(usageController.text) ?? 1,
                                applicableFor: CacheService.applicableFor,
                              ),
                            );
                          }
                        },
                      )),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- Helper Widgets ---

  Widget _buildSheetLabel(String label) => Padding(
    padding: EdgeInsets.only(bottom: 8.h, left: 2.w),
    child: CustomText(text: label, fontSize: 14.sp, fontWeight: FontWeight.bold),
  );

  Widget _buildSheetInputField({required String hint, bool isLarge = false, Widget? suffixIcon, TextEditingController? controller, TextInputType? keyboardType}) {
    return Container(
      height: isLarge ? 100.h : 48.h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: Colors.grey.shade200)),
      child: TextField(
        controller: controller,
        maxLines: isLarge ? 5 : 1,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: isLarge ? 10.h : 0),
          hintText: hint,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildWhiteCard({required Widget child}) => Container(
    padding: EdgeInsets.all(15.r),
    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(25.r)),
    child: child,
  );
}