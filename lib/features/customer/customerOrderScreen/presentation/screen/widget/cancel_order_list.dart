import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widgets/custom_text.dart';
import 'order_history_tab.dart';


// class CancelOrderList extends StatelessWidget {
//   const CancelOrderList({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> canceledItems = ["Item 1", "Item 2", "Item 3"];
//
//     return ListView.builder(
//       padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
//       itemCount: canceledItems.length + 1,
//       itemBuilder: (context, index) {
//
//         if (index == 0) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(
//                   text: "Canceled Order",
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold
//               ),
//               SizedBox(height: 20.h),
//             ],
//           );
//         }
//
//         // The rest are the Booking Cards
//         return const OrderHistoryCard(
//           studioName: "Skin Care Center",
//           serviceName: "Acne Treatment",
//           date: "Canceled on 04/10",
//           status: "Canceled",
//         );
//       },
//     );
//   }
// }
