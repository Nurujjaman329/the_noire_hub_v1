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
    final bool isAsset = !imageUrl.startsWith('http');

    // Create a color filter if a color is provided but no complex filter exists
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
            color: color, // Direct tint for assets
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
            colorFilter: effectiveColorFilter, // Applies the tint here
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
      baseColor: Colors.grey.withValues(alpha:0.6),
      highlightColor: Colors.grey.withValues(alpha:0.3),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          border: border,
          color: Colors.grey.withValues(alpha:0.6),
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
        color: Colors.grey.withValues(alpha:0.6),
        borderRadius: borderRadius,
        shape: boxShape,
      ),
      child: const Icon(Icons.error, color: Colors.white),
    );
  }
}