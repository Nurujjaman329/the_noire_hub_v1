import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/route_constants.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. Header with Logo (Pinned) - Reusing your moss green app bar
          _buildSliverAppBar(),

          // 2. Main Content Card
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: Offset(0, -0.5.r),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.r),
                    topRight: Radius.circular(50.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25.w, 30.h, 25.w, 25.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 3. Add Bank Button
                      Center(
                        child: GestureDetector(
                          onTap: () {
                           Get.toNamed(RouteConstants.addBankScreen);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: const Color(0XFFF1F0B2), // Light yellow
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: const Color(0xFF9BB575), width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.account_balance_wallet_outlined, size: 18.sp, color: const Color(0xFF1D3826)),
                                SizedBox(width: 8.w),
                                CustomText(
                                  text: "Add Bank",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1D3826),
                                  textDecoration: TextDecoration.underline,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // 4. Balance Cards
                      _buildBalanceCard("Total Balance", "\$19.500.00", isPrimary: true),
                      SizedBox(height: 15.h),
                      _buildBalanceCard("Total Withdrawal Balance", "\$15.500.00", isPrimary: false),

                      SizedBox(height: 30.h),

                      // 5. Transaction History Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: "Transactions History",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1D3826),
                          ),
                          GestureDetector(
                            onTap: () {}, // See all logic
                            child: CustomText(
                              text: "See all",
                              fontSize: 12.sp,
                              color: Colors.grey,
                              textDecoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),

                      // 6. Transaction List Item
                      _buildTransactionTile(),

                      SizedBox(height: 40.h),

                      // 7. Withdraw Button
                      CustomButton(
                        text: "Withdraw balance",
                        onTap: () => showWithdrawalSheet(context),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Header/Sliver Logic (Reused) ---
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180.h,
      backgroundColor: const Color(0xFF9BB575),
      pinned: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Center(
          child: CustomNetworkImage(
            imageUrl: AppImages.appLogo,
            height: 60.h,
            width: 150.w,
            fit: BoxFit.contain,
          ),
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
        onPressed: () => Get.back(),
      ),
    );
  }

  // --- New Wallet UI Helpers ---

  Widget _buildBalanceCard(String title, String amount, {required bool isPrimary}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF9BB575).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
          SizedBox(height: 10.h),
          const Divider(color: Colors.grey, thickness: 0.5),
          SizedBox(height: 10.h),
          CustomText(
            text: amount,
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: isPrimary ? const Color(0xFF1D3826) : Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile() {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "Withdrawal", fontSize: 14.sp, fontWeight: FontWeight.bold),
          const Divider(color: Colors.grey, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Total Amount :", fontSize: 12.sp, color: Colors.grey),
              CustomText(text: "Completed : \$100", fontSize: 12.sp, color: Colors.green, fontWeight: FontWeight.bold),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: "Payment Date :", fontSize: 12.sp, color: Colors.grey),
              CustomText(text: "12 Jan 25 8.00AM", fontSize: 12.sp, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }

  void showWithdrawalSheet(BuildContext context) {
    int selectedBankIndex = 0; // Local state for bank selection

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFD9E9B3), // Light green background from image
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.all(25.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. Bank Selection Container
                    Container(
                      padding: EdgeInsets.all(15.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "Select Your Bank",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 15.h),

                          // Bank Option 1
                          _buildBankSelectRow(
                            index: 0,
                            selectedIndex: selectedBankIndex,
                            bankName: "Dhaka Bank",
                            accNumber: "XX45 654X 31131",
                            onChanged: (val) => setModalState(() => selectedBankIndex = val!),
                          ),
                          const Divider(height: 30),

                          // Bank Option 2
                          _buildBankSelectRow(
                            index: 1,
                            selectedIndex: selectedBankIndex,
                            bankName: "Dhaka Bank",
                            accNumber: "XX45 654X 31131",
                            onChanged: (val) => setModalState(() => selectedBankIndex = val!),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // 2. Amount Input Field
                    Container(
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Your Amount",
                          prefixIcon: Icon(Icons.monetization_on_outlined, color: Colors.grey, size: 22.sp),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                        ),
                      ),
                    ),

                    SizedBox(height: 25.h),

                    // 3. Final Withdrawal Button
                    CustomButton(
                      text: "Withdrawal",
                      onTap: () {
                        // Final withdrawal processing logic
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// Helper Widget for the Bank Radio Rows
  Widget _buildBankSelectRow({
    required int index,
    required int selectedIndex,
    required String bankName,
    required String accNumber,
    required Function(int?) onChanged,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF1D3826),
          radius: 18.r,
          child: Icon(Icons.credit_card, color: Colors.white, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "Bank Name : $bankName", fontSize: 12.sp, fontWeight: FontWeight.w600),
              CustomText(text: "AC Number : $accNumber", fontSize: 11.sp, color: Colors.grey),
            ],
          ),
        ),
        Radio<int>(
          value: index,
          groupValue: selectedIndex,
          activeColor: const Color(0xFF1D3826),
          onChanged: onChanged,
        ),
      ],
    );
  }
}