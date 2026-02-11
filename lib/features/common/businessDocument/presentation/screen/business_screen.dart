import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_noire_hub_v1/features/common/businessDocument/presentation/screen/tabs/business_documents_tab.dart';
import 'package:the_noire_hub_v1/features/common/businessDocument/presentation/screen/tabs/business_earnings_tab.dart';
import 'package:the_noire_hub_v1/features/common/businessDocument/presentation/screen/tabs/business_info_tab.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_text.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "",
          showBackButton: true,
        ),
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Business",
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                left: 20.w,
                top: 20.h,
                bottom: 15.h,
              ),

              /// TAB BAR (UI SAME)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.divider.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: AppColors.transparent,
                  indicator: BoxDecoration(
                    color: const Color(0XFFCADA9F),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  labelColor: const Color(0XFF000000),
                  unselectedLabelColor: AppColors.geryColor,
                  labelStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: "Info"),
                    Tab(text: "Earnings"),
                    Tab(text: "Documents"),
                  ],
                ),
              ),

              /// TAB VIEW (Separated)
              const Expanded(
                child: TabBarView(
                  children: [
                    BusinessInfoTab(),
                    BusinessEarningsTab(),
                    BusinessDocumentsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
