import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final BoxFit fit;
  final Color? color;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    required this.imageUrl,
    this.backgroundColor,
    required this.height,
    required this.width,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Check for empty URL or local file paths
    if (imageUrl.isEmpty) return _buildErrorWidget();

    final bool isFile = imageUrl.startsWith('/') || imageUrl.contains('file://');
    final bool isAsset = !imageUrl.startsWith('http') && !isFile;

    if (isFile) {
      return Container(
        height: height, width: width,
        decoration: BoxDecoration(
          border: border, borderRadius: borderRadius,
          shape: boxShape, color: backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: boxShape == BoxShape.circle
              ? BorderRadius.circular(height)
              : (borderRadius ?? BorderRadius.zero),
          child: Image.file(
            File(imageUrl),
            height: height,
            width: width,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
          ),
        ),
      );
    }

    final effectiveColorFilter = colorFilter ??
        (color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null);

    if (isAsset) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
          color: backgroundColor,
        ),
        child: ClipRRect(
          borderRadius: boxShape == BoxShape.circle
              ? BorderRadius.circular(height)
              : (borderRadius ?? BorderRadius.zero),
          child: Image.asset(
            imageUrl,
            height: height,
            width: width,
            fit: fit,
            color: color,
            colorBlendMode: color != null ? BlendMode.srcIn : null,
            errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
          color: backgroundColor,
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
            colorFilter: effectiveColorFilter,
          ),
        ),
        child: child,
      ),
      // Uses Shimmer for a "smooth loading" look
      placeholder: (context, url) => _buildPlaceholder(),
      // Uses a default icon for "broken" or missing images
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
  }

  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: border,
          borderRadius: borderRadius,
          shape: boxShape,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: border,
        // Light grey background for empty state
        color: const Color(0xFFF2F2F2),
        borderRadius: borderRadius,
        shape: boxShape,
      ),
      child: Icon(
        // Shows a person icon if it's likely a profile, otherwise a generic image icon
        boxShape == BoxShape.circle ? Icons.person : Icons.image_not_supported_outlined,
        color: Colors.grey[400],
        size: (height * 0.4), // Responsive icon size
      ),
    );
  }
}