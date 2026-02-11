import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';


class AddPromoScreen extends StatelessWidget {
  const AddPromoScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final promoController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Add Promo",  showBackButton: true,),

      body: Padding(
        padding:  EdgeInsets.symmetric(vertical: 50.h,horizontal: 20.w),
        child: Column(
          children: [
            CustomTextField(
              controller: promoController,
              keyboardType: TextInputType.number,
              hintText: "Promo or Gift Card Code",
              // Using custom padding to match your previous design
              contenpaddingVertical: 12.h,

            ),
            SizedBox(
              height: 50.h,
            ),

            CustomButton(onTap: (){}, text: "Redeem",height: 40.h,textColor : Color(0XFF000000), color: const Color(0xFFCADA9F))
          ],
        ),
      ),
    );
  }
}
