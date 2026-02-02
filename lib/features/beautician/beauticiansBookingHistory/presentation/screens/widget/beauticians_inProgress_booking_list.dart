import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/custom_text.dart';
import 'beauticians_booking_history_card.dart';


class BeauticiansInprogressBookingList extends StatelessWidget {
  const BeauticiansInprogressBookingList({super.key});

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
                    text: "In-Progress Booking",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold
                ),
                SizedBox(height: 20.h),
              ],
            );
          }

          return const BeauticiansBookingHistoryCard(
            studioName: "Skin Care Center",
            serviceName: "Acne Treatment",
            date: "In Progress on 04/10",
            status: "In Progress",
          );
        }
    );



  }
}