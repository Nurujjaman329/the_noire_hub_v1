// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../../../core/accountController/account_controller.dart';
// import '../../../../../core/constants/app_assets.dart';
// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/constants/route_constants.dart';
// import '../../../../../core/widgets/custom_network_image.dart';
// import '../../../../../core/widgets/custom_text.dart';
// import '../../../../../core/widgets/dialog_helper.dart';
//
// class StoreScreen extends StatefulWidget {
//   const StoreScreen({super.key});
//
//   @override
//   State<StoreScreen> createState() => _StoreScreenState();
// }
//
// class _StoreScreenState extends State<StoreScreen> {
//   // Track toggle state
//   bool isLiveMode = true;
//
//   @override
//   Widget build(BuildContext context) {
//     final AccountController accountCtrl = Get.find<AccountController>();
//
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             // 1. Header Background (Static in background)
//             _buildHeaderBackground(),
//
//             // 2. Content Layer
//             Column(
//               children: [
//                 // Transparent space to let header show through
//                 SizedBox(height: 160.h),
//
//                 // 3. The Main Content Card
//                 Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(50.r),
//                       topRight: Radius.circular(50.r),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       // THIS IS THE KEY: Pull the image up so it sits on the line
//                       Transform.translate(
//                         offset: Offset(0, -60.h),
//                         child: _buildFloatingProfileImage(),
//                       ),
//
//                       // Reduce height since Transform moved the image up
//                       Transform.translate(
//                         offset: Offset(0, -40.h),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20.w),
//                           child: Column(
//                             children: [
//                               _buildStoreInfo(),
//
//                               Padding(
//                                 padding: EdgeInsets.symmetric(vertical: 15.h),
//                                 child: Divider(color: AppColors.geryColor.withValues(alpha:0.2), thickness: 1),
//                               ),
//
//                               _buildTextButtonsToggle(),
//
//                               SizedBox(height: 10.h),
//                               _buildProductCategory(accountCtrl.isBeautician ? "Hair Services" : "Hair Care", showEdit: isLiveMode),
//                               _buildProductCategory(accountCtrl.isBeautician ? "Skin Services" : "Skin Care", showEdit: isLiveMode),
//
//                               SizedBox(height: 100.h),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderBackground() {
//     return SizedBox(
//       height: 240.h, // Set the fixed height of your background
//       child: Stack(
//         children: [
//           CustomNetworkImage(
//             imageUrl: AppAssets.vendorStoreTop,
//             height: 240.h,
//             width: double.infinity,
//             borderRadius: BorderRadius.zero,
//             fit: BoxFit.cover,
//           ),
//           Positioned(
//             top: 0,
//             right: 0,
//             child: CustomNetworkImage(
//               imageUrl: AppAssets.vendorStoreShadow,
//               height: 140.h,
//               width: 220.w,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFloatingProfileImage() {
//     return Container(
//       padding: EdgeInsets.all(5.r),
//       decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//       child: Stack(
//         children: [
//           CustomNetworkImage(
//             imageUrl: "https://images.pexels.com/photos/3762882/pexels-photo-3762882.jpeg",
//             height: 110.r,
//             width: 110.r,
//             boxShape: BoxShape.circle,
//           ),
//           if (isLiveMode)
//             Positioned(
//               bottom: 0,
//               right: 0,
//               child: CircleAvatar(
//                 radius: 18.r,
//                 backgroundColor: AppColors.primaryDark,
//                 child: Icon(Icons.camera_alt, color: Colors.white, size: 16.sp),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStoreInfo() {
//     return Column(
//       children: [
//         CustomText(
//           text: "Ada’s Body Shop",
//           fontSize: 22.sp,
//           fontWeight: FontWeight.bold,
//           color: Color(0XFF1D3826),
//           // color: AppColors.primaryDark,
//         ),
//         SizedBox(height: 10.h),
//         CustomText(
//           text: "Shop home-made products that are tailored to tropical climates, black skin and black hair.",
//           textAlign: TextAlign.center,
//           fontSize: 11.sp,
//           color: Color(0x80000000),
//           // color: AppColors.geryColor,
//           height: 1.4,
//         ),
//         SizedBox(height: 12.h),
//
//         // --- NEW SEPARATED INFO ROW ---
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _infoTile("2-Day Delivery"),
//               _infoDivider(),
//               _infoTile("10-Day Shipping"),
//               _infoDivider(),
//               _infoTile("Open 9 am - 9 pm"),
//               _infoDivider(),
//               GestureDetector(
//                 onTap: () {
//                   // More Details Logic
//                 },
//                 child: CustomText(
//                   text: "More Details",
//                   fontSize: 9.sp,
//                   color: AppColors.primaryDark,
//                   fontWeight: FontWeight.bold,
//                   textDecoration: TextDecoration.underline,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Helper widget for the info text
//   Widget _infoTile(String text) {
//     return CustomText(
//       text: text,
//       fontSize: 9.sp,
//       color: Color(0XFFB5B475),
//       // color: AppColors.geryColor,
//       fontWeight: FontWeight.w500,
//     );
//   }
//
//   // Helper widget for the vertical separator |
//   Widget _infoDivider() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.w),
//       child: CustomText(
//         text: "|",
//         fontSize: 10.sp,
//         color: AppColors.geryColor.withValues(alpha:0.5),
//       ),
//     );
//   }
//
//   // --- REPLACED TAB WITH TEXT BUTTONS ---
//   Widget _buildTextButtonsToggle() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         GestureDetector(
//           onTap: () {
//             GlobalDialogs.showActionRequiredDialog(
//               onVerifyTap: () {
//                 Get.toNamed(RouteConstants.businessScreen);
//               },
//               onFulfillmentTap: () {
//                 Get.toNamed(RouteConstants.orderFullFillMent);
//               },
//                 onClose: () {
//                   Get.find<AccountController>().dismissDialog();
//                 }
//             );
//           },
//           child: CustomText(
//             text: "Go Live",
//             color: Color(0XFFB5B475),
//             // color: AppColors.secondaryVariant,
//             fontSize: 14.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         GestureDetector(
//           onTap: () => setState(() => isLiveMode = false),
//           child: CustomText(
//             text: "Preview",
//             color: Color(0XFFB5B475),
//             // color: AppColors.secondaryVariant,
//             fontSize: 14.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildProductCategory(String category, {required bool showEdit}) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.only(top: 25.h, bottom: 15.h),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   CustomText(text: category, fontSize: 18.sp, fontWeight: FontWeight.bold),
//                   if (showEdit) SizedBox(width: 5.w),
//                   if (showEdit) Icon(Icons.edit_note, size: 20.sp, color: AppColors.geryColor),
//                 ],
//               ),
//               if (showEdit)
//                 GestureDetector(
//                   onTap: () { /* Add Section Logic */ },
//                   child: Row(
//                     children: [
//                       Icon(Icons.add_circle_outline, size: 18.sp, color: AppColors.background),
//                       CustomText(
//                         text: Get.find<AccountController>().isBeautician ? "Add Service" : "Add Product",
//                         fontSize: 11.sp,
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.background,
//                         left: 5.w,
//                       ),
//                     ],
//                   ),
//                 )
//             ],
//           ),
//         ),
//         GridView.builder(
//           shrinkWrap: true,
//           padding: EdgeInsets.zero,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: 2,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 0.78,
//             crossAxisSpacing: 15.w,
//             mainAxisSpacing: 15.h,
//           ),
//           itemBuilder: (context, index) => _buildProductCard(showEdit: showEdit),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildProductCard({required bool showEdit}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0XFFF0F0EC),
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(8.r),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15.r),
//                 child: const CustomNetworkImage(
//                   imageUrl: "https://images.pexels.com/photos/4041391/pexels-photo-4041391.jpeg",
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   height: 70,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomText(
//                   text: Get.find<AccountController>().isBeautician ? "Hair Styling Service" : "Argan Oil Serum",
//                   fontSize: 11.sp,
//                   fontWeight: FontWeight.bold,
//                   maxLines: 1,
//                   color: const Color(0XFF000000),
//                 ),
//                 SizedBox(height: 4.h),
//                 CustomText(
//                   text: "21 Blends",
//                   fontSize: 9.sp,
//                   color: const Color(0x99000000),
//                 ),
//                 SizedBox(height: 5.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CustomText(
//                       text: "\$17.99",
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.bold,
//                       color: const Color(0XFF000000),
//                     ),
//
//                     // --- REPLACED EDIT ICON WITH POPUP MENU ---
//                     if (showEdit)
//                       PopupMenuButton<String>(
//                         color: Color(0XFF627E4C),
//                         padding: EdgeInsets.zero,
//                         constraints: BoxConstraints(minWidth: 100.w),
//                         icon: Icon(Icons.more_vert, size: 18.sp, color: AppColors.geryColor),
//                         onSelected: (value) {
//                           if (value == 'edit') {
//                             // TODO: Add Edit Logic
//                             debugPrint("Edit Clicked");
//                           } else if (value == 'delete') {
//                             // TODO: Add Delete Logic
//                             debugPrint("Delete Clicked");
//                           }
//                         },
//                         itemBuilder: (BuildContext context) => [
//                           PopupMenuItem(
//                             value: 'edit',
//                             height: 35.h,
//                             child: Row(
//                               children: [
//                                 Icon(Icons.edit, size: 14.sp, color: Color(0XFFF1F0B2)),
//                                 SizedBox(width: 8.w),
//                                 CustomText(text: "Edit", fontSize: 12.sp,color: Color(0XFFF1F0B2)),
//                               ],
//                             ),
//                           ),
//                           PopupMenuItem(
//                             value: 'delete',
//                             height: 35.h,
//                             child: Row(
//                               children: [
//                                 Icon(Icons.delete, size: 14.sp, color: Colors.red),
//                                 SizedBox(width: 8.w),
//                                 CustomText(text: "Delete", fontSize: 12.sp, color: Colors.red),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//
// }