import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_network_image.dart';
import '../../../../../core/widgets/custom_text.dart';
import '../../data/withdraw_history_response_model.dart';
import '../controller/wallet_info_controller.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize or find your controller
    final controller = Get.find<WalletInfoController>();

    return Scaffold(
      backgroundColor: const Color(0xFF2D3E2F), // primaryDark
      body: RefreshIndicator(
        onRefresh: () => controller.onRefresh(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: Offset(0, -0.5.r),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.r),
                      topRight: Radius.circular(50.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25.w, 30.h, 25.w, 25.h),
                    child: Obx(() {
                      final wallet = controller.walletAttributes.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30.h),

                          // 4. Balance Cards using real data
                          _buildBalanceCard(
                              "Total Balance",
                              "\$${wallet.balance.toStringAsFixed(2)}",
                              isPrimary: true
                          ),
                          SizedBox(height: 15.h),
                          _buildBalanceCard(
                              "Total Withdrawal Balance",
                              "\$${wallet.totalWithdrawn.toStringAsFixed(2)}",
                              isPrimary: false
                          ),

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
                                onTap: () {},
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

                          // 6. Static Transaction List (As requested)
                          Obx(() {
                            if (controller.historyLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (controller.withdrawHistory.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Center(
                                  child: CustomText(
                                    text: "No transactions yet",
                                    fontSize: 13.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: controller.withdrawHistory
                                  .map((item) => _buildTransactionTile(item))
                                  .toList(),
                            );
                          }),

                          SizedBox(height: 40.h),

                          // 7. Withdraw Button
                          controller.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : CustomButton(
                            text: "Withdraw balance",
                            onTap: () => showWithdrawalSheet(context, controller),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Header logic ---
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
            imageUrl: AppAssets.appLogo,
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

  Widget _buildBalanceCard(String title, String amount, {required bool isPrimary}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF9BB575).withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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

  Widget _buildTransactionTile(WithdrawalItem item) {
    final isCompleted = item.status.toLowerCase() == "completed";

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Withdrawal",
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
          const Divider(color: Colors.grey, height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: "Total Amount :",
                  fontSize: 12.sp,
                  color: Colors.grey),
              CustomText(
                text: "${isCompleted ? "Completed" : "Pending"} : \$${item.amount}",
                fontSize: 12.sp,
                color: isCompleted ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  text: "Payment Date :",
                  fontSize: 12.sp,
                  color: Colors.grey),
              CustomText(
                text: item.createdAt.substring(0, 10),
                fontSize: 12.sp,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showWithdrawalSheet(BuildContext context, WalletInfoController controller) {
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFD9E9B3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(25.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// ---- AVAILABLE BALANCE CARD ----
                Obx(() {
                  final balance = controller.walletAttributes.value.balance;

                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(18.r),
                    margin: EdgeInsets.only(bottom: 18.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Available Balance",
                          fontSize: 13.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 6.h),
                        CustomText(
                          text: "\$${balance.toStringAsFixed(2)}",
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1D3826),
                        ),
                      ],
                    ),
                  );
                }),

                /// ---- AMOUNT FIELD ----
                Container(
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: amountController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: "Enter Your Amount",
                      prefixIcon: Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.grey,
                        size: 22.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                /// ---- WITHDRAW BUTTON ----
                Obx(() => CustomButton(
                  text: controller.isWithdrawing.value
                      ? "Processing..."
                      : "Withdrawal",
                  onTap: controller.isWithdrawing.value
                      ? null
                      : () {
                    double? enteredAmount =
                    double.tryParse(amountController.text);

                    double availableBalance = controller
                        .walletAttributes.value.balance
                        .toDouble();

                    if (enteredAmount == null || enteredAmount <= 0) {
                      Get.snackbar(
                        "Error",
                        "Please enter a valid amount",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    /// Prevent withdrawing more than balance
                    if (enteredAmount > availableBalance) {
                      Get.snackbar(
                        "Insufficient Funds",
                        "You cannot withdraw more than \$${availableBalance.toStringAsFixed(2)}",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    Navigator.pop(context);
                    controller.requestWithdrawal(enteredAmount);
                  },
                )),

                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }
}