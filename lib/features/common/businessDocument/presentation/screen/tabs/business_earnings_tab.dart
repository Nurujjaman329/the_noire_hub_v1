import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/widgets/custom_text.dart';

class BusinessEarningsTab extends StatelessWidget {
  const BusinessEarningsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          /// Withdraw Button
          CustomButton(
            onTap: () {},
            text: "Withdraw Funds",
            color: const Color(0XFF627E4C),
            height: 50.h,
          ),

          SizedBox(height: 25.h),

          /// Stats Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 15.h,
            crossAxisSpacing: 15.w,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard("Available", "\$255.50"),
              _buildStatCard("Pending", "\$125.50"),
              _buildStatCard("This Month", "\$890.50"),
              _buildStatCard("Total Earned", "\$5125.85"),
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

          /// Bar Chart
          Container(
            height: 200.h,
            padding: EdgeInsets.only(top: 20.h, right: 20.w),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),

                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (val, meta) {
                        const days = [
                          "Mon",
                          "Tue",
                          "Wed",
                          "Thu",
                          "Fri",
                          "Sat",
                          "Sun"
                        ];
                        return CustomText(
                          text: days[val.toInt()],
                          fontSize: 10.sp,
                          color: AppColors.geryColor,
                        );
                      },
                    ),
                  ),
                  leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                ),

                borderData: FlBorderData(show: false),

                barGroups: [
                  _makeGroupData(0, 45),
                  _makeGroupData(1, 60),
                  _makeGroupData(2, 85),
                  _makeGroupData(3, 70),
                  _makeGroupData(4, 55),
                  _makeGroupData(5, 90),
                  _makeGroupData(6, 75),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// -----------------------
  /// Helper Widgets
  /// -----------------------

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
          color: AppColors.divider,
          width: 25.w,
          borderRadius: BorderRadius.circular(8.r),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: AppColors.white,
          ),
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
          CustomText(
            text: value,
            color: AppColors.white,
            fontSize: 10.sp,
          ),
          Icon(
            Icons.arrow_drop_down,
            color: AppColors.white,
            size: 15.sp,
          ),
        ],
      ),
    );
  }
}
