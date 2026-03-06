import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscureCharacrter;
  final Color? filColor;
  final int? maxLines;
  final IconData? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contenpaddingHorizontal;
  final double? contenpaddingVertical;
  final Widget? suffixIcons;
  final FormFieldValidator? validator;
  final VoidCallback? onTab;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;
  final bool isOptional;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.contenpaddingHorizontal,
    this.contenpaddingVertical,
    this.hintText,
    this.prefixIcon,
    this.suffixIcons,
    this.validator,
    this.isEmail,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.obscureCharacrter = '*',
    this.filColor,
    this.maxLines = 1,
    this.labelText,
    this.isPassword = false,
    this.readOnly = false,
    this.isOptional = false,
    this.onTab,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;
  // 🔥 FIX: Add an explicit FocusNode
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    // 🔥 FIX: Unfocus and dispose node to stop it from
    // calling the controller after the widget is gone
    _focusNode.unfocus();
    _focusNode.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      maxLines: widget.maxLines,
      onTap: widget.onTab,
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscureCharacrter ?? '*',
      validator: widget.validator,
      cursorColor: Colors.black,
      obscureText: widget.isPassword ? obscureText : false,
      style: TextStyle(
        color: const Color(0xFF000000),
        fontSize: 16.sp,
      ),
      decoration: InputDecoration(
        filled: widget.filColor != null,
        fillColor: widget.filColor,
        labelText: widget.isOptional ? "${widget.labelText} (Optional)" : widget.labelText,
        labelStyle: TextStyle(
          color: Colors.black54,
          fontSize: 14.sp,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: const Color(0xFF000000),
            fontSize: 14.sp,
            // fontWeight: FontWeight.bold
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
          widget.prefixIcon,
          color: Colors.grey.shade600,
          size: 22.sp,
        )
            : null,
        prefixIconConstraints: BoxConstraints(minWidth: 40.w),
        contentPadding: EdgeInsets.symmetric(
          vertical: widget.contenpaddingVertical ?? 16.h,
          horizontal: widget.contenpaddingHorizontal ?? 15.w,
        ),
        border: _buildOutlineBorder(color: Colors.grey.shade400),
        enabledBorder: _buildOutlineBorder(color: Colors.grey.shade400),
        focusedBorder: _buildOutlineBorder(color: const Color(0xFF000000)),
        errorBorder: _buildOutlineBorder(color: Colors.red),
        focusedErrorBorder: _buildOutlineBorder(color: Colors.red, width: 1.5),
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: toggle,
          icon: Icon(
            obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.black54,
            size: 20.sp,
          ),
        )
            : widget.suffixIcons,
      ),
    );
  }

  OutlineInputBorder _buildOutlineBorder({required Color color, double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(
        width: width.w,
        color: color,
      ),
    );
  }
}