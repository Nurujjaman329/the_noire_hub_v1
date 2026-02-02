import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    this.maxLine,
    this.textOverflow,
    this.fontName,
    this.textDecoration = TextDecoration.none,
    this.textAlign = TextAlign.start, // Changed to start as it's more common for general text
    this.decorationColor = Colors.transparent,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize = 14,
    this.textHeight,
    this.fontWeight = FontWeight.w400,
    this.color = AppColors.textPrimary,
    this.text = "",
    this.letterSpacing, // Added optional
    this.fontStyle,     // Added optional (Italic/Normal)
    this.softWrap,      // Added optional
  });

  final double left;
  final TextOverflow? textOverflow;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final Color decorationColor;
  final TextAlign textAlign;
  final int? maxLine;
  final String? fontName;
  final double? textHeight;
  final TextDecoration? textDecoration;
  final double? letterSpacing;
  final FontStyle? fontStyle;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLine,
        overflow: textOverflow ?? (maxLine != null ? TextOverflow.ellipsis : null),
        softWrap: softWrap,
        style: TextStyle(
          decoration: textDecoration,
          fontSize: fontSize,
          decorationColor: decorationColor, // Fixed: now uses variable instead of hardcoded black
          fontFamily: fontName ?? "Outfit",
          fontWeight: fontWeight,
          color: color,
          height: textHeight,
          letterSpacing: letterSpacing,
          fontStyle: fontStyle,
        ),
      ),
    );
  }
}