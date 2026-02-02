import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/custom_text.dart';
import 'vendor_order_history_card.dart';

class VendorPendingOrderList extends StatelessWidget {
  const VendorPendingOrderList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> canceledItems = ["Item 1", "Item 2", "Item 3"];

    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),

        itemCount: canceledItems.length + 1,
        itemBuilder: (context,index){

          if(index == 0 ) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                    text: "Pending Order",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold
                ),
                SizedBox(height: 20.h),
              ],
            );
          }

          return const VendorOrderHistoryCard(
            studioName: "Skin Care Center",
            serviceName: "Acne Treatment",
            date: "Directly After Payment ",
            status: "Pending",
          );
        }
    );



  }
}