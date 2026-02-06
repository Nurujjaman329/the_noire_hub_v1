
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text.dart';



class AddBankScreen extends StatelessWidget {
  const AddBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "", showBackButton: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          children: [
            // 1. Add Bank Account Form Section
            _buildFormContainer(
              title: "Add your bank account information",
              child: Column(
                children: [
                  _buildIconInputField(hint: "Name", icon: Icons.person_outline),
                  SizedBox(height: 15.h),
                  _buildIconInputField(hint: "Bank Name", icon: Icons.account_balance_outlined),
                  SizedBox(height: 15.h),
                  _buildIconInputField(hint: "Account Number", icon: Icons.credit_card_outlined),
                  SizedBox(height: 25.h),
                  CustomButton(
                    text: "Add account",
                    onTap: () {
                      // Logic to save bank account
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // 2. My Bank List Section
            _buildFormContainer(
              title: "My Bank",
              child: Column(
                children: [
                  _buildBankListItem("Dhaka Bank", "XX45 654X 31131"),
                  const Divider(height: 30, thickness: 1),
                  _buildBankListItem("Dhaka Bank", "XX45 654X 31131"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper for the bordered sections
  Widget _buildFormContainer({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF9BB575).withValues(alpha:0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1D3826),
          ),
          SizedBox(height: 20.h),
          child,
        ],
      ),
    );
  }

  // Helper for input fields with leading icons
  Widget _buildIconInputField({required String hint, required IconData icon}) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey, size: 22.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
        ),
      ),
    );
  }

  // Helper for individual bank items in the list
  Widget _buildBankListItem(String bankName, String accNumber) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: const Color(0xFF1D3826),
          radius: 18.r,
          child: Icon(Icons.credit_card, color: Colors.white, size: 18.sp),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: "Bank Name : $bankName", fontSize: 13.sp, color: Colors.black87),
              CustomText(text: "AC Number : $accNumber", fontSize: 13.sp, color: Colors.black87),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // Delete bank logic
          },
          child: CircleAvatar(
            backgroundColor: Colors.red.shade50,
            radius: 15.r,
            child: Icon(Icons.close, color: Colors.red, size: 16.sp),
          ),
        ),
      ],
    );
  }
}