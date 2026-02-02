import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;
  final Color? bgColor;
  final Color? arrowColor;
  final bool showBackButton;
  final List<Widget>? actions; // ADDED: To support cart icon or other buttons

  const CustomAppBar({
    super.key,
    required this.title,
    this.bottom,
    this.bgColor,
    this.arrowColor,
    this.showBackButton = false,
    this.actions, // ADDED
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor ?? AppColors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? InkWell(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 18.sp,
          color: arrowColor ?? AppColors.textPrimary,
        ),
      )
          : null,
      title: CustomText(
        text: title,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
      actions: actions, // ADDED: This enables the icons on the right side
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      bottom == null ? kToolbarHeight : kToolbarHeight + bottom!.preferredSize.height);
}
