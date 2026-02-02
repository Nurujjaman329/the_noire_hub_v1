
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';
import 'custom_text.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final T? value;
  final List<T> items;
  final String Function(T) itemAsString;
  final ValueChanged<T?>? onChanged;
  final bool isOptional;
  final IconData? prefixIcon;
  final double? contentPaddingVertical;
  final Color? iconColor;

  // New properties for the Country Box style
  final bool isBoxStyle;
  final double? width;
  final double? height;

  const CustomDropdown({
    super.key,
    this.labelText,
    this.hintText,
    required this.value,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    this.isOptional = false,
    this.isBoxStyle = false, // Default is your underline style
    this.prefixIcon,
    this.contentPaddingVertical,
    this.iconColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget dropdown = DropdownButtonFormField<T>(
      value: value,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: iconColor ?? AppColors.geryColor,
        size: 18.sp,
      ),
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14.sp,
        fontFamily: "Outfit",
      ),
      // If box style, we hide the default decoration borders
      decoration: InputDecoration(
        filled: isBoxStyle,
        fillColor: isBoxStyle ? const Color(0xFFF3F3F3) : Colors.transparent,
        labelText: isBoxStyle ? null : (isOptional ? "$labelText (Optional)" : labelText),
        labelStyle: TextStyle(color: Colors.black54, fontSize: 14.sp, fontFamily: "Outfit"),
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey.shade400, size: 22.sp) : null,
        prefixIconConstraints: BoxConstraints(minWidth: 40.w),
        contentPadding: EdgeInsets.symmetric(
          vertical: contentPaddingVertical ?? (isBoxStyle ? 10.h : 8.h),
          horizontal: isBoxStyle ? 10.w : 0,
        ),
        // Switch between Underline or No Border based on isBoxStyle
        border: isBoxStyle ? OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none) : _buildUnderlineBorder(),
        enabledBorder: isBoxStyle ? OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none) : _buildUnderlineBorder(),
        focusedBorder: isBoxStyle ? OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide.none) : _buildUnderlineBorder(color: Colors.black),
      ),
      items: items.map((T item) => DropdownMenuItem<T>(value: item, child: Text(itemAsString(item)))).toList(),
      onChanged: onChanged,
    );

    // If it's the Country Box, wrap it in a sized container and add the label on top
    if (isBoxStyle) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            CustomText(
              text: labelText!,
              fontSize: 13.sp,
              color: AppColors.geryColor.withOpacity(0.8),
              bottom: 8.h,
            ),
          SizedBox(
            width: width ?? 85.w,
            height: height ?? 50.h,
            child: dropdown,
          ),
        ],
      );
    }

    return dropdown;
  }

  UnderlineInputBorder _buildUnderlineBorder({Color color = Colors.grey}) {
    return UnderlineInputBorder(
      borderSide: BorderSide(width: 1.w, color: color.withOpacity(0.5)),
    );
  }
}