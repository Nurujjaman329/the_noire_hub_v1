import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/custom_text.dart';
import '../../../../earning/presentation/controller/earning_controller.dart';

class BusinessEarningsTab extends StatelessWidget {
  const BusinessEarningsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the controller
    final controller = Get.find<EarningsController>();

    return RefreshIndicator(
      onRefresh: () => controller.onRefresh(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Obx(() {
          if (controller.isLoading.value && controller.transactions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final wallet = controller.wallet.value;

          return Column(
            children: [


              SizedBox(height: 25.h),

              /// Stats Grid (Dynamic Data)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15.h,
                crossAxisSpacing: 15.w,
                childAspectRatio: 1.4,
                children: [
                  _buildStatCard("Available", "\$${wallet.available}"),
                  _buildStatCard("Pending", "\$${wallet.pendingBalance}"),
                  _buildStatCard("This Month", "\$${wallet.thisMonth}"),
                  _buildStatCard("Total Earned", "\$${wallet.totalEarned}"),
                ],
              ),

              SizedBox(height: 30.h),

              /// Chart Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Earnings",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  _buildSmallDropdown("Weekly"),
                ],
              ),

              SizedBox(height: 20.h),

              /// Dynamic Bar Chart
              controller.chartData.isEmpty
                  ? const SizedBox(height: 200, child: Center(child: Text("No data available")))
                  : Container(
                height: 200.h,
                padding: EdgeInsets.only(top: 20.h, right: 20.w),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    // Dynamic Max Y based on data
                    maxY: controller.chartData.map((e) => e.amount).fold(100.0, (prev, curr) => curr > prev! ? curr.toDouble() : prev),
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            int index = val.toInt();
                            if (index >= 0 && index < controller.chartData.length) {
                              // Take first 3 letters of the label (e.g., "Monday" -> "Mon")
                              String label = controller.chartData[index].label;
                              return CustomText(
                                text: label.length > 3 ? label.substring(0, 3) : label,
                                fontSize: 10.sp,
                                color: AppColors.geryColor,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true, drawVerticalLine: false),
                    borderData: FlBorderData(show: false),
                    // Dynamic Bar Groups from API
                    barGroups: controller.chartData.asMap().entries.map((entry) {
                      return _makeGroupData(entry.key, entry.value.amount.toDouble());
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0XFFE3E6DB),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: label,
            fontSize: 12.sp,
            color: AppColors.geryColor,
          ),
          CustomText(
            text: value,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            top: 5.h,
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0XFF627E4C), // Use your theme green here
          width: 20.w,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ],
    );
  }

  Widget _buildSmallDropdown(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0XFF99A86F),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          CustomText(text: value, color: AppColors.white, fontSize: 10.sp),
          Icon(Icons.arrow_drop_down, color: AppColors.white, size: 15.sp),
        ],
      ),
    );
  }
}