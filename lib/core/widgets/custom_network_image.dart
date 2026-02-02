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
  final BoxFit fit; // Added to make the widget more flexible

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
  });

  @override
  Widget build(BuildContext context) {
    // 1. Check if the image is a local asset
    final bool isAsset = !imageUrl.startsWith('http');

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
          // Ensure the asset follows the borderRadius/shape
          borderRadius: boxShape == BoxShape.circle
              ? BorderRadius.circular(height)
              : (borderRadius ?? BorderRadius.zero),
          child: Image.asset(
            imageUrl,
            height: height,
            width: width,
            fit: fit,
            color: colorFilter != null ? Colors.white : null,
            colorBlendMode: colorFilter != null ? BlendMode.dstIn : null,
            errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
          ),
        ),
      );
    }

    // 2. Otherwise, treat as a Network Image
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
            colorFilter: colorFilter,
          ),
        ),
        child: child,
      ),
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
    );
  }

  // Extracted Placeholder for cleaner code
  Widget _buildPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.6),
      highlightColor: Colors.grey.withOpacity(0.3),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          color: Colors.grey.withOpacity(0.6),
          borderRadius: borderRadius,
          shape: boxShape,
        ),
      ),
    );
  }

  // Extracted Error Widget for cleaner code
  Widget _buildErrorWidget() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: border,
        color: Colors.grey.withOpacity(0.6),
        borderRadius: borderRadius,
        shape: boxShape,
      ),
      child: const Icon(Icons.error, color: Colors.white),
    );
  }
}